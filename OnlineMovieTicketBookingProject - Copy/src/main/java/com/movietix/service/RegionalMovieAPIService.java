package com.movietix.service;

import com.movietix.model.TMDBMovie;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class RegionalMovieAPIService {

    private static final String TMDB_URL = "https://api.themoviedb.org/3/discover/movie?certification_country=IN&with_original_language=hi%7Cte%7Cta%7Cml%7Ckn&sort_by=popularity.desc";

    // In-memory cache variables
    private static List<TMDBMovie> cachedMovies = null;
    private static long cacheExpiryTime = 0;
    private static final long CACHE_DURATION_MS = 15 * 60 * 1000; // 15 minutes cache expiration

    private static final HttpClient httpClient = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(5))
            .build();

    /**
     * Fetches movies from TMDB API or returns cached movies if cache is valid.
     * Thread-safe query execution.
     */
    public static synchronized List<TMDBMovie> getRegionalMovies(String apiToken) {
        long currentTime = System.currentTimeMillis();

        // Return from cache if valid
        if (cachedMovies != null && currentTime < cacheExpiryTime) {
            return cachedMovies;
        }

        // Token validation and fallback
        if (apiToken == null || apiToken.trim().isEmpty() || "YOUR_TMDB_API_KEY_HERE".equals(apiToken.trim())) {
            // Check fallback system properties
            apiToken = System.getProperty("TMDB_API_TOKEN");
        }

        if (apiToken == null || apiToken.trim().isEmpty() || "YOUR_TMDB_API_KEY_HERE".equals(apiToken.trim())) {
            System.err.println("[MovieTix] TMDB API token is missing or default placeholder.");
            return (cachedMovies != null) ? cachedMovies : Collections.emptyList();
        }

        try {
            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(TMDB_URL))
                    .header("accept", "application/json")
                    .header("Authorization", "Bearer " + apiToken.trim())
                    .GET()
                    .timeout(Duration.ofSeconds(10))
                    .build();

            HttpResponse<String> response = httpClient.send(request, HttpResponse.BodyHandlers.ofString());

            if (response.statusCode() == 200) {
                List<TMDBMovie> parsed = parseMoviesJson(response.body());
                if (!parsed.isEmpty()) {
                    cachedMovies = parsed;
                    cacheExpiryTime = currentTime + CACHE_DURATION_MS;
                    System.out.println("[MovieTix] Successfully fetched and cached " + parsed.size()
                            + " regional spotlight movies.");
                }
            } else {
                System.err.println("[MovieTix] TMDB API returned HTTP status code: " + response.statusCode());
            }
        } catch (Exception e) {
            System.err.println("[MovieTix] Error fetching movies from TMDB: " + e.getMessage());
        }

        return (cachedMovies != null) ? cachedMovies : Collections.emptyList();
    }

    private static List<TMDBMovie> parseMoviesJson(String json) {
        List<TMDBMovie> list = new ArrayList<>();
        try {
            int resultsIndex = json.indexOf("\"results\"");
            if (resultsIndex == -1)
                return list;

            int startBracket = json.indexOf("[", resultsIndex);
            if (startBracket == -1)
                return list;

            // Search for end bracket balancing brace counts
            int bracketCount = 1;
            int endBracket = -1;
            for (int i = startBracket + 1; i < json.length(); i++) {
                char c = json.charAt(i);
                if (c == '[')
                    bracketCount++;
                else if (c == ']') {
                    bracketCount--;
                    if (bracketCount == 0) {
                        endBracket = i;
                        break;
                    }
                }
            }
            if (endBracket == -1)
                return list;

            String resultsArrayStr = json.substring(startBracket + 1, endBracket).trim();
            if (resultsArrayStr.isEmpty())
                return list;

            // Segment array content balancing quotes and inner braces
            List<String> objectStrs = new ArrayList<>();
            int braceCount = 0;
            int objectStart = -1;
            boolean insideQuotes = false;
            for (int i = 0; i < resultsArrayStr.length(); i++) {
                char c = resultsArrayStr.charAt(i);
                if (c == '"' && (i == 0 || resultsArrayStr.charAt(i - 1) != '\\')) {
                    insideQuotes = !insideQuotes;
                }
                if (!insideQuotes) {
                    if (c == '{') {
                        if (braceCount == 0) {
                            objectStart = i;
                        }
                        braceCount++;
                    } else if (c == '}') {
                        braceCount--;
                        if (braceCount == 0 && objectStart != -1) {
                            objectStrs.add(resultsArrayStr.substring(objectStart, i + 1));
                        }
                    }
                }
            }

            for (String objStr : objectStrs) {
                String id = extractField(objStr, "id");
                String title = extractField(objStr, "title");
                String overview = extractField(objStr, "overview");
                String posterPath = extractField(objStr, "poster_path");
                String voteAvgStr = extractField(objStr, "vote_average");
                String releaseDate = extractField(objStr, "release_date");

                double voteAverage = 0.0;
                if (!voteAvgStr.isEmpty()) {
                    try {
                        voteAverage = Double.parseDouble(voteAvgStr);
                    } catch (NumberFormatException ignored) {
                    }
                }

                list.add(new TMDBMovie(id, title, overview, posterPath, voteAverage, releaseDate));
            }
        } catch (Exception e) {
            System.err.println("[MovieTix] Failed to parse custom TMDB JSON: " + e.getMessage());
        }
        return list;
    }

    private static String extractField(String jsonObjectStr, String key) {
        String searchKey = "\"" + key + "\":";
        int index = jsonObjectStr.indexOf(searchKey);
        if (index == -1)
            return "";
        int valStart = index + searchKey.length();
        while (valStart < jsonObjectStr.length() && Character.isWhitespace(jsonObjectStr.charAt(valStart))) {
            valStart++;
        }
        if (valStart >= jsonObjectStr.length())
            return "";

        char firstChar = jsonObjectStr.charAt(valStart);
        if (firstChar == '"') {
            StringBuilder sb = new StringBuilder();
            for (int i = valStart + 1; i < jsonObjectStr.length(); i++) {
                char c = jsonObjectStr.charAt(i);
                if (c == '"' && jsonObjectStr.charAt(i - 1) != '\\') {
                    break;
                }
                sb.append(c);
            }
            return unescapeJava(sb.toString());
        } else {
            StringBuilder sb = new StringBuilder();
            int braceCounter = 0;
            int bracketCounter = 0;
            for (int i = valStart; i < jsonObjectStr.length(); i++) {
                char c = jsonObjectStr.charAt(i);
                if (c == '{')
                    braceCounter++;
                else if (c == '}') {
                    if (braceCounter == 0)
                        break;
                    braceCounter--;
                } else if (c == '[')
                    bracketCounter++;
                else if (c == ']') {
                    if (bracketCounter == 0)
                        break;
                    bracketCounter--;
                } else if (c == ',' && braceCounter == 0 && bracketCounter == 0) {
                    break;
                }
                sb.append(c);
            }
            return sb.toString().trim();
        }
    }

    private static String unescapeJava(String str) {
        if (str == null)
            return null;
        StringBuilder out = new StringBuilder();
        for (int i = 0; i < str.length(); i++) {
            char ch = str.charAt(i);
            if (ch == '\\' && i + 1 < str.length()) {
                char next = str.charAt(i + 1);
                if (next == '\"') {
                    out.append('\"');
                    i++;
                } else if (next == '\\') {
                    out.append('\\');
                    i++;
                } else if (next == '/') {
                    out.append('/');
                    i++;
                } else if (next == 'n') {
                    out.append('\n');
                    i++;
                } else if (next == 'u' && i + 5 < str.length()) {
                    try {
                        int code = Integer.parseInt(str.substring(i + 2, i + 6), 16);
                        out.append((char) code);
                        i += 5;
                    } catch (NumberFormatException e) {
                        out.append(ch);
                    }
                } else {
                    out.append(ch);
                }
            } else {
                out.append(ch);
            }
        }
        return out.toString();
    }
}

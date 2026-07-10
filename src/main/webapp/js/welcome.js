/* welcome.js — MovieTix Cinematic Splash Animation Engine */

document.addEventListener('DOMContentLoaded', () => {
    const overlay = document.getElementById('movietix-welcome-overlay');
    const canvas = document.getElementById('welcome-particle-canvas');
    if (!overlay) return;

    // Check if the splash screen should play in this session
    let welcomePlayed = false;
    try {
        welcomePlayed = sessionStorage.getItem('movietix_welcome_played');
    } catch (e) {
        console.warn("sessionStorage is unavailable:", e);
    }

    if (welcomePlayed) {
        overlay.style.display = 'none';
        overlay.remove();
        return;
    }

    // Set sessionStorage flag immediately
    try {
        sessionStorage.setItem('movietix_welcome_played', 'true');
    } catch (e) {
        console.warn("sessionStorage is unavailable:", e);
    }

    // Canvas Particle Setup
    if (canvas) {
        const ctx = canvas.getContext('2d');
        let particles = [];
        let animationFrameId = null;

        const resizeCanvas = () => {
            canvas.width = window.innerWidth;
            canvas.height = window.innerHeight;
        };
        resizeCanvas();
        window.addEventListener('resize', resizeCanvas);

        // Generate Gold Particles
        const createParticles = (count) => {
            particles = [];
            for (let i = 0; i < count; i++) {
                particles.push({
                    x: Math.random() * canvas.width,
                    y: Math.random() * canvas.height,
                    size: Math.random() * 2.2 + 0.3,
                    speedX: (Math.random() - 0.5) * 0.3, // slow drift
                    speedY: -Math.random() * 0.4 - 0.1, // slow float up
                    opacity: Math.random() * 0.5 + 0.2,
                    fadeSpeed: Math.random() * 0.005 + 0.002
                });
            }
        };
        createParticles(45);

        // Particle rendering loop
        const animateParticles = () => {
            ctx.clearRect(0, 0, canvas.width, canvas.height);
            ctx.shadowBlur = 8;
            ctx.shadowColor = '#D4AF37';

            for (let i = 0; i < particles.length; i++) {
                let p = particles[i];
                ctx.fillStyle = `rgba(212, 175, 55, ${p.opacity})`;

                ctx.beginPath();
                ctx.arc(p.x, p.y, p.size, 0, Math.PI * 2);
                ctx.fill();

                // Update position
                p.x += p.x < 0 || p.x > canvas.width ? -p.x : p.speedX;
                p.y += p.speedY;

                // Recycle particle if it floats off-screen
                if (p.y < 0) {
                    p.y = canvas.height;
                    p.x = Math.random() * canvas.width;
                    p.opacity = Math.random() * 0.5 + 0.2;
                }
            }
            animationFrameId = requestAnimationFrame(animateParticles);
        };
        animateParticles();

        // Stop animation upon overlay disposal to conserve performance
        overlay.addEventListener('transitionend', () => {
            if (animationFrameId) {
                cancelAnimationFrame(animationFrameId);
            }
            window.removeEventListener('resize', resizeCanvas);
        });
    }

    // Schedule overlay fade-out and removal
    setTimeout(() => {
        overlay.classList.add('fade-out');
        setTimeout(() => {
            overlay.remove();
        }, 1200); // Allow slide+fade transition to finish before dropping DOM node
    }, 3200);
});

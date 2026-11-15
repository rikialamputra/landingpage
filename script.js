// Professional Mikrotik Services JavaScript

document.addEventListener('DOMContentLoaded', function() {
    // Mikhmon Form Toggle
    const toggleMikhmonBtn = document.getElementById('toggleMikhmonBtn');
    const mikhmonForm = document.getElementById('mikhmonForm');
    
    if (toggleMikhmonBtn && mikhmonForm) {
        toggleMikhmonBtn.addEventListener('click', function() {
            mikhmonForm.classList.toggle('hidden');
            toggleMikhmonBtn.textContent = mikhmonForm.classList.contains('hidden') 
                ? 'Ingin mencobanya?'
                : 'Sembunyikan Form';
        });
    }

    // Mikhmon Form Submission
    if (mikhmonForm) {
        mikhmonForm.addEventListener('submit', function(event) {
            event.preventDefault();
            
            const nama = document.getElementById('nama').value.trim();
            const wa = document.getElementById('wa').value.trim();
            const subdomain = document.getElementById('subdomain').value.trim();
            const langganan = document.getElementById('langganan').value.trim();
            const versiros = document.getElementById('versiros').value.trim();

            if (!nama || !wa || !subdomain || !langganan || !versiros) {
                alert('Mohon lengkapi semua field yang diperlukan.');
                return;
            }

            const message = `Halo, saya ingin mendaftar Mikhmon Online, berikut data diri saya:

Nama: ${nama}
No WA: ${wa}
Subdomain: ${subdomain}
Langganan: ${langganan}
Versi ROS: ${versiros}`;

            const encodedMessage = encodeURIComponent(message);
            const whatsappUrl = `https://wa.me/6285315803571?text=${encodedMessage}`;
            
            window.open(whatsappUrl, '_blank');
            
            // Show success message
            alert('Permintaan terkirim! Anda akan diarahkan ke WhatsApp.');
        });
    }

    // Portfolio Show More
    const showMoreBtn = document.getElementById('showMoreBtn');
    const hiddenPortfolioCards = document.querySelectorAll('.portfolio-card.hidden');
    
    if (showMoreBtn && hiddenPortfolioCards.length > 0) {
        showMoreBtn.addEventListener('click', function() {
            hiddenPortfolioCards.forEach(card => {
                card.classList.remove('hidden');
            });
            showMoreBtn.style.display = 'none';
        });
    }

    // Smooth Scrolling for Anchor Links
    document.querySelectorAll('a[href^="#"]').forEach(anchor => {
        anchor.addEventListener('click', function(e) {
            e.preventDefault();
            const target = document.querySelector(this.getAttribute('href'));
            if (target) {
                target.scrollIntoView({
                    behavior: 'smooth',
                    block: 'start'
                });
            }
        });
    });

    // Add scroll-triggered animations
    const observerOptions = {
        threshold: 0.1,
        rootMargin: '0px 0px -50px 0px'
    };

    const observer = new IntersectionObserver(function(entries) {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.style.opacity = '1';
                entry.target.style.transform = 'translateY(0)';
            }
        });
    }, observerOptions);

    // Observe elements for animation
    const animatedElements = document.querySelectorAll('.service-card, .portfolio-card, .about-card');
    animatedElements.forEach(el => {
        el.style.opacity = '0';
        el.style.transform = 'translateY(30px)';
        el.style.transition = 'opacity 0.6s ease, transform 0.6s ease';
        observer.observe(el);
    });

    // Form validation enhancement
    const inputs = document.querySelectorAll('input[required]');
    inputs.forEach(input => {
        input.addEventListener('blur', function() {
            if (!this.value.trim()) {
                this.style.borderColor = '#ef4444';
            } else {
                this.style.borderColor = 'rgba(255, 255, 255, 0.3)';
            }
        });

        input.addEventListener('input', function() {
            if (this.style.borderColor === '#ef4444' && this.value.trim()) {
                this.style.borderColor = 'rgba(255, 255, 255, 0.3)';
            }
        });
    });

    // Phone number formatting for WhatsApp field
    const waInput = document.getElementById('wa');
    if (waInput) {
        waInput.addEventListener('input', function(e) {
            let value = e.target.value.replace(/\D/g, '');
            if (value.startsWith('0')) {
                value = '62' + value.substring(1);
            } else if (!value.startsWith('62')) {
                value = '62' + value;
            }
            // Don't update the displayed value, just store for processing
            this.dataset.formatted = value;
        });
    }

    // Loading animation for buttons
    const ctaButtons = document.querySelectorAll('.btn-primary');
    ctaButtons.forEach(button => {
        if (button.getAttribute('href') && button.getAttribute('href').includes('wa.me')) {
            button.addEventListener('click', function() {
                const originalText = this.innerHTML;
                this.innerHTML = '<span>⏳</span> Membuka WhatsApp...';
                this.style.pointerEvents = 'none';
                
                setTimeout(() => {
                    this.innerHTML = originalText;
                    this.style.pointerEvents = 'auto';
                }, 3000);
            });
        }
    });

// ...existing code...
    // Add typing effect to hero title
    const heroTitle = document.querySelector('.hero-title');
    if (heroTitle) {
        // Ambil teks murni (tanpa tag) dan deteksi teks yang di-highlight
        const highlightEl = heroTitle.querySelector('.highlight');
        const highlightText = highlightEl ? highlightEl.textContent : null;
        const fullText = heroTitle.textContent.trim();

        // Siapkan elemen kosong untuk mengetik
        heroTitle.innerHTML = '<span class="typing"></span>';
        heroTitle.style.opacity = '1';
        const typingEl = heroTitle.querySelector('.typing');

        let idx = 0;
        const highlightStart = highlightText ? fullText.indexOf(highlightText) : -1;

        function typeWriter() {
            if (idx < fullText.length) {
                // Jika mencapai posisi highlight, buat span.highlight dan isi karakternya
                if (highlightText && idx === highlightStart) {
                    typingEl.insertAdjacentHTML('beforeend', '<span class="highlight"></span>');
                    const currentHighlight = typingEl.querySelector('.highlight');
                    // tambahkan seluruh teks highlight sekaligus supaya tidak memecah tag
                    for (let j = 0; j < highlightText.length; j++) {
                        currentHighlight.textContent += fullText.charAt(idx);
                        idx++;
                    }
                    // lanjutkan setelah sedikit jeda
                    setTimeout(typeWriter, 50);
                    return;
                }

                // tambahkan karakter biasa
                typingEl.textContent += fullText.charAt(idx);
                idx++;
                setTimeout(typeWriter, 40);
            }
        }

        // Mulai setelah delay singkat
        setTimeout(typeWriter, 500);
    }
// ...existing code...
});

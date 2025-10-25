// Scroll fluide pour les ancres
document.querySelectorAll('a.nav-link[href^="#"]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
        const targetId = this.getAttribute('href').substring(1);
        const target = document.getElementById(targetId);
        if (target) {
            e.preventDefault();
            window.scrollTo({
                top: target.offsetTop - 70,
                behavior: 'smooth'
            });
            // Collapse navbar si mobile
            const navbarCollapse = document.getElementById('mainNavbar');
            if (navbarCollapse.classList.contains('show')) {
                new bootstrap.Collapse(navbarCollapse).toggle();
            }
        }
    });
});

// --- Bascule entre vue "devis" et "trafic" ---
const traficBtn = document.getElementById('traficBtn'); // L'élément à cliquer
const devisSection = document.getElementById('devisSection'); // Section devis
const traficSection = document.getElementById('traficSection'); // Section trafic

let traficActive = false;

if (traficBtn && devisSection && traficSection) {
    traficBtn.addEventListener('click', () => {
        traficActive = !traficActive;
        if (traficActive) {
            devisSection.style.display = 'none';
            traficSection.style.display = '';
        } else {
            devisSection.style.display = '';
            traficSection.style.display = 'none';
        }
    });
}

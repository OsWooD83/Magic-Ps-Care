document.addEventListener('DOMContentLoaded', function () {
    const form = document.getElementById('registerForm');
    if (!form) return;
    form.addEventListener('submit', async function (e) {
        e.preventDefault();
        const nom = document.getElementById('reg-nom').value;
        const email = document.getElementById('reg-email').value;
        const password = document.getElementById('reg-password').value;
        const msg = document.getElementById('registerMsg');
        msg.textContent = '';
        try {
            const res = await fetch('https://backend-ps-care.onrender.com/api/register', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ nom, email, password })
            });
            const data = await res.json();
            if (data.success) {
                msg.textContent = 'Inscription réussie !';
                msg.style.color = 'limegreen';
                form.reset();
            } else {
                msg.textContent = data.error || 'Erreur lors de l\'inscription.';
                msg.style.color = 'red';
            }
        } catch (err) {
            msg.textContent = 'Erreur réseau ou serveur.';
            msg.style.color = 'red';
        }
    });
});

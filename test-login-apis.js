// Test des APIs en production Vercel
async function testAPIs() {
    console.log('🧪 Test des APIs Magic PS Care...\n');
    
    const testData = {
        email: 'admin@magicpscare.com',
        password: 'admin123'
    };
    
    // Test 1: API directe /api/login
    console.log('1️⃣ Test API directe /api/login');
    try {
        const response = await fetch('/api/login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testData)
        });
        
        const data = await response.json();
        console.log('✅ Status:', response.status);
        console.log('✅ Response:', data);
    } catch (error) {
        console.log('❌ Erreur API directe:', error.message);
    }
    
    console.log('\n');
    
    // Test 2: API proxy /api/proxy
    console.log('2️⃣ Test API proxy /api/proxy?endpoint=login');
    try {
        const response = await fetch('/api/proxy?endpoint=login', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(testData)
        });
        
        const data = await response.json();
        console.log('✅ Status:', response.status);
        console.log('✅ Response:', data);
    } catch (error) {
        console.log('❌ Erreur API proxy:', error.message);
    }
    
    console.log('\n');
    
    // Test 3: API fallback JS
    console.log('3️⃣ Test API fallback JS');
    try {
        if (window.API_CONFIG) {
            const data = await window.API_CONFIG.login(testData);
            console.log('✅ API_CONFIG Response:', data);
        } else {
            console.log('❌ API_CONFIG non disponible');
        }
    } catch (error) {
        console.log('❌ Erreur API fallback:', error.message);
    }
    
    console.log('\n🎯 Tests terminés');
}

// Lancer les tests quand la page est chargée
if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', testAPIs);
} else {
    testAPIs();
}

// Script de diagnostic Vercel
async function diagnosticVercel() {
    console.log('🔍 Diagnostic Vercel - Magic PS Care');
    console.log('=====================================\n');
    
    const baseUrl = 'https://tw-pascal-ajxtrf9fg-association-ps-cares-projects.vercel.app';
    
    // Test de base - page d'accueil
    console.log('1️⃣ Test page d\'accueil...');
    try {
        const response = await fetch(baseUrl);
        console.log(`✅ Statut: ${response.status}`);
        console.log(`✅ Type: ${response.headers.get('content-type')}`);
    } catch (error) {
        console.log('❌ Erreur:', error.message);
    }
    
    console.log('\n2️⃣ Test structure API...');
    
    // Test endpoints disponibles
    const endpoints = [
        '/api/login',
        '/api/session', 
        '/api/proxy',
        '/api/stats/devis'
    ];
    
    for (const endpoint of endpoints) {
        try {
            console.log(`🔍 Test ${endpoint}...`);
            const response = await fetch(baseUrl + endpoint, {
                method: 'GET'
            });
            console.log(`  ✅ Status: ${response.status} ${response.statusText}`);
            
            if (response.headers.get('content-type')?.includes('application/json')) {
                const data = await response.json();
                console.log(`  📝 Response:`, data);
            }
        } catch (error) {
            console.log(`  ❌ Erreur: ${error.message}`);
        }
    }
    
    console.log('\n3️⃣ Test login complet...');
    
    // Test login avec données valides
    try {
        const response = await fetch(baseUrl + '/api/login', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            credentials: 'include',
            body: JSON.stringify({
                email: 'admin@magicpscare.com',
                password: 'admin123'
            })
        });
        
        console.log(`✅ Login Status: ${response.status} ${response.statusText}`);
        
        const contentType = response.headers.get('content-type');
        console.log(`✅ Content-Type: ${contentType}`);
        
        if (contentType?.includes('application/json')) {
            const data = await response.json();
            console.log(`✅ Login Response:`, JSON.stringify(data, null, 2));
        } else {
            const text = await response.text();
            console.log(`❌ Response non-JSON:`, text.substring(0, 200) + '...');
        }
        
    } catch (error) {
        console.log('❌ Erreur login:', error.message);
    }
    
    console.log('\n🎯 Diagnostic terminé');
}

// Auto-exécution
if (typeof window !== 'undefined') {
    // Dans le navigateur
    window.diagnosticVercel = diagnosticVercel;
    console.log('🔧 Fonction diagnosticVercel() disponible');
} else {
    // En Node.js
    diagnosticVercel().catch(console.error);
}

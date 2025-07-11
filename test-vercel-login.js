// Test API Login sur Vercel en production
const https = require('https');

const testData = {
    email: 'admin@magicpscare.com',
    password: 'admin123'
};

// URL de base (ajustez selon votre déploiement)
const BASE_URL = 'https://tw-pascal-9h8xbqc25-association-ps-cares-projects.vercel.app';

async function testAPI(endpoint, method = 'POST', data = null) {
    return new Promise((resolve, reject) => {
        const url = new URL(endpoint, BASE_URL);
        
        const options = {
            hostname: url.hostname,
            port: 443,
            path: url.pathname + url.search,
            method: method,
            headers: {
                'Content-Type': 'application/json',
                'User-Agent': 'Test-Script/1.0'
            }
        };

        const req = https.request(options, (res) => {
            let responseData = '';
            
            res.on('data', (chunk) => {
                responseData += chunk;
            });
            
            res.on('end', () => {
                try {
                    const parsed = JSON.parse(responseData);
                    resolve({
                        status: res.statusCode,
                        statusMessage: res.statusMessage,
                        data: parsed,
                        headers: res.headers
                    });
                } catch (error) {
                    resolve({
                        status: res.statusCode,
                        statusMessage: res.statusMessage,
                        data: responseData,
                        headers: res.headers
                    });
                }
            });
        });

        req.on('error', (error) => {
            reject(error);
        });

        if (data) {
            req.write(JSON.stringify(data));
        }
        
        req.end();
    });
}

async function runTests() {
    console.log('🧪 Test APIs Magic PS Care sur Vercel\n');
    console.log(`🔗 URL de base: ${BASE_URL}\n`);
    
    // Test 1: API directe /api/login
    console.log('1️⃣ Test /api/login');
    try {
        const result = await testAPI('/api/login', 'POST', testData);
        console.log(`✅ Status: ${result.status} ${result.statusMessage}`);
        console.log(`✅ Response:`, JSON.stringify(result.data, null, 2));
    } catch (error) {
        console.log(`❌ Erreur:`, error.message);
    }
    
    console.log('\n');
    
    // Test 2: API proxy
    console.log('2️⃣ Test /api/proxy?endpoint=login');
    try {
        const result = await testAPI('/api/proxy?endpoint=login', 'POST', testData);
        console.log(`✅ Status: ${result.status} ${result.statusMessage}`);
        console.log(`✅ Response:`, JSON.stringify(result.data, null, 2));
    } catch (error) {
        console.log(`❌ Erreur:`, error.message);
    }
    
    console.log('\n');
    
    // Test 3: Test session
    console.log('3️⃣ Test /api/session');
    try {
        const result = await testAPI('/api/session', 'GET');
        console.log(`✅ Status: ${result.status} ${result.statusMessage}`);
        console.log(`✅ Response:`, JSON.stringify(result.data, null, 2));
    } catch (error) {
        console.log(`❌ Erreur:`, error.message);
    }
    
    console.log('\n🎯 Tests terminés');
}

runTests().catch(console.error);

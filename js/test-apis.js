// Test simple des APIs Vercel
(async function testAPIs() {
  console.log('🔍 Test des APIs Vercel depuis le navigateur...');
  
  // APIs GET (lecture)
  const getEndpoints = ['/api/session', '/api/avis', '/api/devis-stats'];
  
  for (const endpoint of getEndpoints) {
    try {
      const response = await fetch(endpoint);
      const data = await response.json();
      console.log(`✅ ${endpoint}: ${response.status}`, data);
    } catch (error) {
      console.log(`❌ ${endpoint}: ERREUR`, error.message);
    }
  }
  
  // Test LOGIN (POST)
  try {
    const loginResponse = await fetch('/api/login', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: 'test@test.com', password: 'test' })
    });
    const loginData = await loginResponse.json();
    console.log(`✅ /api/login (POST): ${loginResponse.status}`, loginData);
  } catch (error) {
    console.log(`❌ /api/login: ERREUR`, error.message);
  }
  
  // Test LOGOUT (POST)
  try {
    const logoutResponse = await fetch('/api/logout', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' }
    });
    const logoutData = await logoutResponse.json();
    console.log(`✅ /api/logout (POST): ${logoutResponse.status}`, logoutData);
  } catch (error) {
    console.log(`❌ /api/logout: ERREUR`, error.message);
  }
  
  console.log('🎉 Test terminé !');
})();

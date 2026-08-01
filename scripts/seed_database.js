/**
 * ButlerAI - Database Seed Script
 * Node.js script per popolare il database Supabase
 * 
 * Uso:
 *   node seed_database.js
 * 
 * Requisiti:
 *   - Node.js installato
 *   - dotenv installato (npm install dotenv)
 *   - @supabase/supabase-js installato (npm install @supabase/supabase-js)
 *   - File .env con SUPABASE_URL e SUPABASE_SERVICE_ROLE_KEY
 */

require('dotenv').config();
const { createClient } = require('@supabase/supabase-js');

// Configurazione Supabase
const supabaseUrl = process.env.SUPABASE_URL || 'https://tuo-progetto.supabase.co';
const supabaseKey = process.env.SUPABASE_SERVICE_ROLE_KEY || 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';

// Inizializza client con service role key (per bypassare RLS)
const supabase = createClient(supabaseUrl, supabaseKey, {
  db: {
    schema: 'public',
  },
});

// Categorie di abbonamenti
const categories = [
  { name: 'Streaming', icon: '📺', is_custom: false },
  { name: 'AI & Tooling', icon: '🤖', is_custom: false },
  { name: 'Produttività', icon: '📊', is_custom: false },
  { name: 'Cloud & Storage', icon: '☁️', is_custom: false },
  { name: 'Social & Comunicazione', icon: '💬', is_custom: false },
  { name: 'Gaming', icon: '🎮', is_custom: false },
  { name: 'E-commerce', icon: '🛒', is_custom: false },
  { name: 'Istruzione', icon: '🎓', is_custom: false },
  { name: 'Salute & Fitness', icon: '💪', is_custom: false },
  { name: 'Musica & Audio', icon: '🎵', is_custom: false },
  { name: 'News & Media', icon: '📰', is_custom: false },
  { name: 'Viaggi & Trasporti', icon: '✈️', is_custom: false },
  { name: 'Finanza & Banking', icon: '💳', is_custom: false },
  { name: 'Sicurezza', icon: '🔒', is_custom: false },
  { name: 'Altro', icon: '📦', is_custom: false },
];

// Servizi preimpostati (catalogo)
const catalogServices = [
  // Streaming
  { title: 'Netflix', category: 'Streaming', price: 12.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Standard - 2 schermi' },
  { title: 'Amazon Prime Video', category: 'Streaming', price: 5.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Incluso con Prime' },
  { title: 'Disney+', category: 'Streaming', price: 8.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Standard' },
  { title: 'HBO Max', category: 'Streaming', price: 11.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Standard' },
  { title: 'Apple TV+', category: 'Streaming', price: 9.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Individuale' },
  
  // Musica & Audio
  { title: 'Spotify', category: 'Musica & Audio', price: 10.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Premium - Senza pubblicità' },
  { title: 'Apple Music', category: 'Musica & Audio', price: 10.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Individuale' },
  { title: 'YouTube Music', category: 'Musica & Audio', price: 11.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Premium' },
  { title: 'Amazon Music Unlimited', category: 'Musica & Audio', price: 10.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Individuale' },
  
  // AI & Tooling
  { title: 'ChatGPT Plus', category: 'AI & Tooling', price: 20.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Accesso a GPT-4 e funzionalità avanzate' },
  { title: 'Midjourney', category: 'AI & Tooling', price: 10.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Piano Basic - 200 job/mese' },
  { title: 'GitHub Pro', category: 'AI & Tooling', price: 4.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Repository privati illimitati' },
  { title: 'GitHub Copilot', category: 'AI & Tooling', price: 10.00, currency: 'USD', billing_cycle: 'monthly', notes: 'AI pair programming' },
  { title: 'DALL-E 3', category: 'AI & Tooling', price: 20.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Generazione immagini AI' },
  
  // Produttività
  { title: 'Notion', category: 'Produttività', price: 10.00, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Plus - Collaborazione avanzata' },
  { title: 'Trello', category: 'Produttività', price: 5.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Piano Standard - Team fino a 10 membri' },
  { title: 'Asana', category: 'Produttività', price: 13.49, currency: 'USD', billing_cycle: 'monthly', notes: 'Piano Premium - Gestione progetti' },
  { title: 'ClickUp', category: 'Produttività', price: 10.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Piano Unlimited' },
  { title: 'Evernote', category: 'Produttività', price: 8.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Premium' },
  
  // Cloud & Storage
  { title: 'Google Drive', category: 'Cloud & Storage', price: 1.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano 100GB' },
  { title: 'iCloud+', category: 'Cloud & Storage', price: 0.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano 50GB' },
  { title: 'Dropbox', category: 'Cloud & Storage', price: 11.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Plus - 2TB' },
  { title: 'OneDrive', category: 'Cloud & Storage', price: 7.00, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Microsoft 365 Personal' },
  { title: 'AWS S3', category: 'Cloud & Storage', price: 0.00, currency: 'USD', billing_cycle: 'usage', notes: 'Pay as you go' },
  
  // Social & Comunicazione
  { title: 'LinkedIn Premium', category: 'Social & Comunicazione', price: 39.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Business - Networking avanzato' },
  { title: 'Twitter Blue', category: 'Social & Comunicazione', price: 8.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Verifica e funzionalità premium' },
  { title: 'Discord Nitro', category: 'Social & Comunicazione', price: 9.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Emoji personalizzate e upload piu'' grandi' },
  
  // Gaming
  { title: 'Xbox Game Pass', category: 'Gaming', price: 12.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Accesso a 100+ giochi' },
  { title: 'PlayStation Plus', category: 'Gaming', price: 11.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Essential' },
  { title: 'Nintendo Switch Online', category: 'Gaming', price: 3.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Gioco online e NES/SNES games' },
  { title: 'EA Play', category: 'Gaming', price: 4.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Accesso a giochi EA' },
  
  // Finanza & Banking
  { title: 'Revolut Premium', category: 'Finanza & Banking', price: 7.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Carte virtuali usa e getta' },
  { title: 'N26 You', category: 'Finanza & Banking', price: 9.90, currency: 'EUR', billing_cycle: 'monthly', notes: 'Conto premium senza commissioni' },
  { title: 'Moneyfarm', category: 'Finanza & Banking', price: 0.00, currency: 'EUR', billing_cycle: 'usage', notes: 'Gestione investimenti - commissioni sul capitale' },
  
  // Sicurezza
  { title: 'NordVPN', category: 'Sicurezza', price: 11.99, currency: 'EUR', billing_cycle: 'monthly', notes: 'Piano Standard' },
  { title: '1Password', category: 'Sicurezza', price: 3.50, currency: 'EUR', billing_cycle: 'monthly', notes: 'Password manager' },
  { title: 'Bitdefender', category: 'Sicurezza', price: 3.33, currency: 'EUR', billing_cycle: 'monthly', notes: 'Antivirus totale' },
  { title: 'LastPass', category: 'Sicurezza', price: 3.00, currency: 'USD', billing_cycle: 'monthly', notes: 'Password manager premium' },
];

// Link per disdetta (esempi)
const cancellationLinks = [
  { service: 'Netflix', url: 'https://www.netflix.com/it/cancelplan', notes: 'Cancella online dal profilo' },
  { service: 'Spotify', url: 'https://www.spotify.com/it/account/subscription/', notes: 'Gestione abbonamento' },
  { service: 'Amazon Prime', url: 'https://www.amazon.it/gp/help/customer/display.html?nodeId=GX7NJQ4ZB8MHFRNJ', notes: 'Cancella Prime membership' },
  { service: 'Disney+', url: 'https://www.disneyplus.com/it-it/account', notes: 'Gestione abbonamento' },
  { service: 'ChatGPT Plus', url: 'https://platform.openai.com/account/billing', notes: 'Cancella da OpenAI account' },
  { service: 'Midjourney', url: 'https://www.midjourney.com/account/', notes: 'Gestione piano' },
  { service: 'GitHub Pro', url: 'https://github.com/settings/billing', notes: 'Downgrade a Free' },
  { service: 'Notion', url: 'https://www.notion.so/my-plan', notes: 'Gestione piano' },
  { service: 'LinkedIn Premium', url: 'https://www.linkedin.com/premium/subscription', notes: 'Cancella premium' },
];

// Alternative consigliate
const recommendations = [
  { forService: 'Netflix', suggested: 'Disney+', price: 8.99, currency: 'EUR', reason: 'Piu'' economico con contenuti originali' },
  { forService: 'Netflix', suggested: 'Amazon Prime Video', price: 5.99, currency: 'EUR', reason: 'Incluso con Prime, spedizioni gratuite' },
  { forService: 'ChatGPT Plus', suggested: 'Mistral Pro', price: 14.00, currency: 'EUR', reason: 'Modelli open-source, prezzo competitivo' },
  { forService: 'Spotify', suggested: 'YouTube Music', price: 11.99, currency: 'EUR', reason: 'Incluso con YouTube Premium' },
  { forService: 'GitHub Pro', suggested: 'GitLab Premium', price: 19.00, currency: 'USD', reason: 'CI/CD integrato, repository illimitati' },
];

/**
 * Inserisce le categorie nel database
 */
async function seedCategories() {
  console.log('📁 Inserimento categorie...');
  
  for (const category of categories) {
    const { data, error } = await supabase
      .from('category')
      .insert([
        {
          name: category.name,
          icon: category.icon,
          is_custom: category.is_custom,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    
    if (error) {
      // Ignora errori di duplicazione
      if (!error.message.includes('duplicate key value violates unique constraint')) {
        console.error(`❌ Errore inserimento categoria ${category.name}:`, error.message);
      }
    } else {
      console.log(`✅ Categoria inserita: ${category.name}`);
    }
  }
}

/**
 * Inserisce i servizi del catalogo
 */
async function seedCatalogServices() {
  console.log('\n📺 Inserimento servizi catalogo...');
  
  // Prima ottieni tutte le categorie
  const { data: categoriesData, error: categoriesError } = await supabase
    .from('category')
    .select('id, name');
  
  if (categoriesError) {
    console.error('❌ Errore recupero categorie:', categoriesError.message);
    return;
  }
  
  const categoryMap = {};
  categoriesData.forEach(cat => {
    categoryMap[cat.name] = cat.id;
  });
  
  for (const service of catalogServices) {
    if (!categoryMap[service.category]) {
      console.warn(`⚠️  Categoria non trovata: ${service.category} - Salto ${service.title}`);
      continue;
    }
    
    const { data, error } = await supabase
      .from('subscription')
      .insert([
        {
          user_id: null, // NULL per catalogo
          title: service.title,
          category_id: categoryMap[service.category],
          price: service.price,
          currency: service.currency,
          billing_cycle: service.billing_cycle,
          next_renewal: null, // NULL per catalogo
          status: 'active',
          source: 'catalog',
          notes: service.notes,
          created_at: new Date().toISOString(),
          updated_at: new Date().toISOString(),
        },
      ])
      .select();
    
    if (error) {
      if (!error.message.includes('duplicate key value violates unique constraint')) {
        console.error(`❌ Errore inserimento servizio ${service.title}:`, error.message);
      }
    } else {
      console.log(`✅ Servizio inserito: ${service.title}`);
    }
  }
}

/**
 * Inserisce i link per disdetta
 */
async function seedCancellationLinks() {
  console.log('\n🔗 Inserimento link disdetta...');
  
  // Ottieni gli ID dei servizi dal catalogo
  const { data: servicesData, error: servicesError } = await supabase
    .from('subscription')
    .select('id, title')
    .eq('user_id', null);
  
  if (servicesError) {
    console.error('❌ Errore recupero servizi:', servicesError.message);
    return;
  }
  
  const serviceMap = {};
  servicesData.forEach(svc => {
    serviceMap[svc.title] = svc.id;
  });
  
  for (const link of cancellationLinks) {
    if (!serviceMap[link.service]) {
      console.warn(`⚠️  Servizio non trovato: ${link.service} - Salto link`);
      continue;
    }
    
    // Usiamo la tabella recommendation per i link di disdetta
    // In alternativa, si potrebbe creare una tabella dedicata
    const { data, error } = await supabase
      .from('recommendation')
      .insert([
        {
          cancelled_subscription_id: serviceMap[link.service],
          suggested_service: `Link Disdetta: ${link.service}`,
          price: 0,
          is_affiliate: false,
          link: `GUIDA: ${link.notes}`,
          url: link.url,
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    
    if (error) {
      if (!error.message.includes('duplicate key value violates unique constraint')) {
        console.error(`❌ Errore inserimento link ${link.service}:`, error.message);
      }
    } else {
      console.log(`✅ Link disdetta inserito: ${link.service}`);
    }
  }
}

/**
 * Inserisce le raccomandazioni
 */
async function seedRecommendations() {
  console.log('\n💡 Inserimento raccomandazioni...');
  
  // Ottieni gli ID dei servizi
  const { data: servicesData, error: servicesError } = await supabase
    .from('subscription')
    .select('id, title')
    .eq('user_id', null);
  
  if (servicesError) {
    console.error('❌ Errore recupero servizi:', servicesError.message);
    return;
  }
  
  const serviceMap = {};
  servicesData.forEach(svc => {
    serviceMap[svc.title] = svc.id;
  });
  
  for (const rec of recommendations) {
    if (!serviceMap[rec.forService]) {
      console.warn(`⚠️  Servizio non trovato: ${rec.forService} - Salto raccomandazione`);
      continue;
    }
    
    const { data, error } = await supabase
      .from('recommendation')
      .insert([
        {
          cancelled_subscription_id: serviceMap[rec.forService],
          suggested_service: rec.suggested,
          price: rec.price,
          is_affiliate: false,
          link: rec.reason,
          url: '',
          created_at: new Date().toISOString(),
        },
      ])
      .select();
    
    if (error) {
      if (!error.message.includes('duplicate key value violates unique constraint')) {
        console.error(`❌ Errore inserimento raccomandazione ${rec.suggested}:`, error.message);
      }
    } else {
      console.log(`✅ Raccomandazione inserita: ${rec.suggested} per ${rec.forService}`);
    }
  }
}

/**
 * Funzione principale
 */
async function main() {
  console.log('🚀 ButlerAI - Database Seed Script');
  console.log('=================================\n');
  
  try {
    // Verifica connessione
    console.log('✓ Connessione a Supabase...');
    const { data, error } = await supabase.from('category').select('*').limit(1);
    if (error) {
      throw error;
    }
    console.log('✓ Connesso con successo!\n');
    
    // Esegui seed
    await seedCategories();
    await seedCatalogServices();
    await seedCancellationLinks();
    await seedRecommendations();
    
    console.log('\n🎉 Seed completato con successo!');
    console.log('\n📊 Statistiche:');
    
    // Conta i record inseriti
    const { count: categoriesCount } = await supabase
      .from('category')
      .select('*', { count: 'exact', head: true });
    
    const { count: servicesCount } = await supabase
      .from('subscription')
      .select('*', { count: 'exact', head: true })
      .eq('user_id', null);
    
    const { count: recommendationsCount } = await supabase
      .from('recommendation')
      .select('*', { count: 'exact', head: true });
    
    console.log(`   - Categorie: ${categoriesCount?.count || 0}`);
    console.log(`   - Servizi catalogo: ${servicesCount?.count || 0}`);
    console.log(`   - Raccomandazioni: ${recommendationsCount?.count || 0}`);
    
  } catch (error) {
    console.error('\n❌ Errore durante il seed:', error.message);
    process.exit(1);
  }
}

// Esegui
main();

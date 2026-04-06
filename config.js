// ============================================
// HYROX LIFE — Supabase Config
// Replace these with YOUR Supabase project values
// Found at: supabase.com → your project → Settings → API
// ============================================
const SUPABASE_URL = 'https://gwoiyqdqoahutybwmjbj.supabase.co';
const SUPABASE_ANON_KEY = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imd3b2l5cWRxb2FodXR5YndtamJqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzQ2ODc3OTUsImV4cCI6MjA5MDI2Mzc5NX0.0l6EaIi-9JJWm-ghHq2VWV1IgL02fdj5GagYpI8brvY';

const db = window.supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);

// ============================================
// Auth Helper — redirect to login if not logged in
// ============================================
async function requireAuth() {
  const { data: { session } } = await db.auth.getSession();
  if (!session) {
    window.location.href = 'index.html';
    return null;
  }
  return session;
}

// ============================================
// Get user profile from DB
// ============================================
async function getUserProfile(userId) {
  const { data, error } = await db
    .from('user_profiles')
    .select('*')
    .eq('id', userId)
    .single();
  return data;
}

// ============================================
// Format date as YYYY-MM-DD
// ============================================
function todayStr() {
  return new Date().toISOString().split('T')[0];
}

function formatDisplayDate(dateStr) {
  const d = new Date(dateStr + 'T00:00:00');
  return d.toLocaleDateString('en-MY', { weekday: 'long', year: 'numeric', month: 'long', day: 'numeric' });
}
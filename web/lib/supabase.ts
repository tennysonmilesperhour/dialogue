import { createClient } from "@supabase/supabase-js";

// The publishable key is public by design; row-level security limits it to
// inserting a waitlist row. It cannot read, update, or delete anything.
// Schema lives in supabase/migrations/0001_dialogue_waitlist.sql. To move the
// waitlist to another project, run that file there and change these two lines.
const SUPABASE_URL = "https://evfogagjbpwzalbkeomc.supabase.co";
const SUPABASE_PUBLISHABLE_KEY = "sb_publishable_Sa9T8kxPY5e27kkOl9HGjA_zSeA52rY";

export const supabase = createClient(SUPABASE_URL, SUPABASE_PUBLISHABLE_KEY);

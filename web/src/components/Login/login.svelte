<script>
  import { supabase } from "../../supabaseClient";

async function Login(){
  
const { data, error } = await supabase.auth.signInWithOAuth({

    provider: 'github'
  
  })  
}

Login()
</script>

  
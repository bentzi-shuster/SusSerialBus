<script>
  import { supabase } from "../../supabaseClient";
  import Table from "./Table.svelte";
 let info 
  async function fun() {
    const { data, error, status } = await supabase.rpc("selectdata");
    // .from('computerinfo')
    // .select().order('uuid', { ascending: false })
    if(status == 401){
      supabase.auth.refreshSession();
    }
    return data;
  }
  
  fun().then((data) => {
    console.log(data);      
    info = data
  })
</script>

<h1>Dashboard</h1>
<div class="center">
  <Table on:selectedtable bind:selectedData={info} mode="dashboard"/>
</div>

<style>
  h1 {
    text-align: center;
    font-size: 5em;
    color: white;
  }
  .center {
    display: flex;
    justify-content: center;
  }
</style>
<!-- 
CREATE OR REPLACE function get_user_no_dupe4()
RETURNS SETOF RECORD AS $$
DECLARE
  rec record;
BEGIN
  for rec in EXECUTE $$ SELECT DISTINCT ON (uuid) * FROM computerinfo ORDER BY uuid, created_at desc$$
  end loop;
  return;
END
$$
language plpgsql;

select get_user_no_dupe4() -->
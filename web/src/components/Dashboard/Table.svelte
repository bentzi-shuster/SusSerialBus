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
        {#if mode == "dashboard"||mode=="view"}
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
    <tr>
    <tr></tr>
    <!-- why does the above work -->
    {#if mode == "dashboard"||mode=="view"}}
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
    }
    th{
        background-color: #272727;
        position: sticky;
        top: 0;

        }
        .tablescroll{
            overflow: scroll;
            max-height: 20em;
        }
        .row{
            cursor: pointer;
           
        }
        .row:hover{
            background-color: #202020;
        }
</style>


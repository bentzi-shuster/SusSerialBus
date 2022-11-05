<script>
    import Navlink from "./navlink.svelte";
    export let pages={};
    export let pageindex;
    import { createEventDispatcher } from 'svelte'; 
    const dispatch = createEventDispatcher();
    let open
</script>
<nav style:height= {open?"10em":""}>
    <button on:click={()=>open=!open}>
    <div class="line"></div>
</button>
{#if open}
    <p>test@test:~$ navlink</p>
<ul>
    
{#each Object.keys(pages) as page,index}
<li>
    <Navlink on:click={()=>{pageindex=index;dispatch("sel",{})}} selected={index=== pageindex} bind:page={page} pageindex={Object.keys(pages).indexOf(page)}/>
</li>
{/each}

</ul>
{/if}
</nav>

<style>
   nav{
    position: fixed;
    bottom: 0;
   }
   nav{
    display: flex;
    flex-direction: column;
    justify-content: space-around;
    align-items: center;
    width: 80%;
    background-color: #1a1a1a;
    color: white;
    font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
    text-decoration: none;
    font-family:FiraCode;
    padding: 0.5rem;
    border-radius: 0.5rem 0.5rem 0 0;
   }
   p{

   }
   .line{
    width: 100px;
    height: 0.2rem;
    background-color: white;
    border-radius: 0.5rem;
   }
   ul{
    justify-content: flex-start;
    list-style: none;
    width: 100%;
    margin-left: 10em;
   }
   li{
    display: flex;
    flex-direction: row;
   }
nav p {
    color: rgb(176, 176, 176);
    font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
    text-decoration: none;
    font-family:FiraCode;
    padding:0 0.5rem ;
    display: inline-flex;
    margin: none;
    align-items: flex-start;
    width: 80vw;
}
</style>
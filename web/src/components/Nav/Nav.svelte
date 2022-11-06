<script>
    import Navlink from "./navlink.svelte";
    export let pages={};
    export let pageindex;
    import { createEventDispatcher } from 'svelte'; 
  import { slide } from 'svelte/transition';
       const dispatch = createEventDispatcher();
    export let open
</script>
{#key open}
<nav in:slide='{{ duration: 500 }}'out:slide='{{ duration: 250 }}' style:height= {open?"10em":""}>
    <button class="line" on:click={()=>open=!open}>
</button>
{#if open}
    <p>nav@test:~$ sudo getlinks</p>
<ul>
    
{#each Object.keys(pages) as page,index}
<li>
    <Navlink desc={Object.values(pages)[index]} on:click={()=>{pageindex=index;dispatch("sel",{})}} selected={index=== pageindex} bind:page={page} pageindex={Object.keys(pages).indexOf(page)}/>
</li>
{/each}

</ul>
{/if}

</nav>
{/key}
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
   .line{
    width: 100px;
    height: 1rem;
    min-height: 1rem;
    background-color: white;
    border-radius: 0.5rem;
    transition: 0.5s ease;
    border: none;
    margin-top: 1em;
   }
   .line:hover{
    width: 150px;
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
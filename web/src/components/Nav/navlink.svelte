<script>
    export let page = "";
    export let pageindex = 0;
    export let selected = false;
    import { createEventDispatcher } from 'svelte'; 
    export let desc;
    const dispatch = createEventDispatcher();
</script>
{#if selected}
  <div>&#62;</div><a href="javascript:void(0)" on:click>{page}</a><p>{desc[1]}</p>
{:else}
    <a href="javascript:void(0)" on:click>{page}</a><p>{desc[1]}</p>
  {/if}

<style>
    a{
        color: white;
        font-family: Cambria, Cochin, Georgia, Times, 'Times New Roman', serif;
        text-decoration: none;
        font-family:FiraCode;
        padding:0 0.5rem ;
        color: lime;
        display: inline-flex;
        margin: none;
    }
    div,p{
display: flex;
 margin: 0;
padding: 0;
    }
    p{
        color:#c0c0c0;
    }
    a:hover{
        text-decoration: underline;
       
    }
</style>
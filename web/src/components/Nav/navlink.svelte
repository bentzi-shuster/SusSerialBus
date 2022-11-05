<script>
    export let page = "";
    export let pageindex = 0;
    export let selected = false;
    import { createEventDispatcher } from 'svelte'; 
    const dispatch = createEventDispatcher();
</script>
{#if selected}
  <div>&#62;</div><a href="javascript:void(0)" on:click>{page}</a>
{:else}
    <a href="javascript:void(0)" on:click>{page}</a>
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
    div{
display: flex;
    }
    a:hover{
        text-decoration: underline;
    }
</style>
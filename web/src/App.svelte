<script>
import Nav from "./components/Nav/Nav.svelte";
import Dashboard from "./components/Dashboard/Dashboard.svelte";
import Home from "./components/Home/Home.svelte";
import View from "./components/View/View.svelte";
const pages={
    "Open Home":Home,
    "Open Dashboard":Dashboard,
    "Open View":View
}
$: pageindex=1;
$: selectedpage=1;
function keydown(e){
switch (e.key) {
    case "ArrowUp":
        if(pageindex>0&&pageindex<=Object.keys(pages).length-1){
            pageindex--;
        }
        break;
    case "ArrowDown":
        if(pageindex>=0&&pageindex<Object.keys(pages).length-1){
            pageindex++;
        }
        break;
    case "Enter":
        selectedpage=pageindex;
        break;
}
}
</script>
<main>
    <div class="center">
            <Nav pages={pages} bind:pageindex={pageindex} on:sel={()=>{selectedpage=pageindex}}/>
            {[pageindex]}
            {selectedpage}
    </div>

    <svelte:component this={pages[Object.keys(pages)[selectedpage]]}/> 


</main>
<svelte:window on:keydown={keydown}/>
<style>
.center{
    display: flex;
    justify-content: center;
    align-items: center;
}
</style>
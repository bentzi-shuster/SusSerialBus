<script>
import Nav from "./components/Nav/Nav.svelte";
import Dashboard from "./components/Dashboard/Dashboard.svelte";
import Home from "./components/Home/Home.svelte";
import View from "./components/View/View.svelte";
  import Login from "./components/Login/login.svelte";
const pages={
    "Open Home":[Home,"info about the project"],
    "Open Dashboard":[Dashboard,"view a bunch of data"],
    "Open View":[View,"view a single computer"],
    "Open Login":Login,
}
$: pageindex=1;
$: selectedpage=1;
let open
function keydown(e){
switch (e.key) {
    case "ArrowUp":
        if(pageindex>0&&pageindex<=Object.keys(pages).length-1){
            pageindex--;
            e.preventDefault();
        }
        break;
    case "ArrowDown":
        if(pageindex>=0&&pageindex<Object.keys(pages).length-1){
            pageindex++;
            e.preventDefault();
        }
        break;
    case "Enter":
        selectedpage=pageindex;
        e.preventDefault();
        break;
        case "k":
            if(e.ctrlKey){
                open=!open;
                e.preventDefault();
            }
}
}
</script>
<main>
    <div class="center">
            <Nav bind:open pages={pages} bind:pageindex={pageindex} on:sel={()=>{selectedpage=pageindex}}/>
    </div>

    <svelte:component on:selectedtable={()=>{selectedpage=2;pageindex=2}} this={pages[Object.keys(pages)[selectedpage]][0]}/>


</main>
<svelte:window on:keydown={keydown}/>
<style>
.center{
    display: flex;
    justify-content: center;
    align-items: center;
}
</style>
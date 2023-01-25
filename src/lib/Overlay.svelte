<script>
    import { fade, scale } from "svelte/transition";
    export let zIndex = 1;
</script>

<div class="overlay-wrap" in:fade out:fade={{duration: 100}}>
    <div
        class="overlay"
        style="z-index: {zIndex}"
        in:scale={{ start: 1.2 }}
        out:fade={{duration: 100}}
    >
        <slot />
    </div>
</div>

<style>
    .overlay-wrap {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        display: flex;
        overflow-x: hidden;
    }
    
    .overlay {
        padding-top: 64px;
        padding-bottom: 16px;
        overflow-y: auto;
        width: 100%;
        display: flex;
        flex-direction: column;
        align-items: center;
        background-color: rgba(0, 0, 0, 0.5);
    }
</style>

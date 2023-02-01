<script>
    import { createEventDispatcher } from "svelte";

    const emit = createEventDispatcher();

    function click() {
        emit("click");
    }
</script>

<button class="item" on:click={click}>
    <slot />
</button>

<style>
    .item {
        margin-bottom: 12px;
        padding: 10px;

        text-align: left;

        background-color: rgb(236, 235, 243);
        border: none;
        border-radius: 8px;
        box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
        transition: 0.1s;
    }

    .item:hover {
        background-color: #fff;
        transform: scale(1.05);
    }

    .item:active {
        background-color: #fff;
        transform: scale(0.95);
    }
</style>

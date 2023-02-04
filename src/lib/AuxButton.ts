import { writable } from 'svelte/store';

const a = writable({
    text: null,
    callback: null
});

export default a;
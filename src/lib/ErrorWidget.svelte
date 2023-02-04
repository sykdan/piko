<div>
    <img src="./assets/error.svg" alt="Error icon" />
    <h2><slot /></h2>
</div>

<style>
    div {
        margin-top: 16px;
        text-align: center;
    }

    h2 {
        color: rgb(155, 0, 0);
    }

    img {
        height: 64px;
        width: 64px;
        text-align: center;
    }
</style>

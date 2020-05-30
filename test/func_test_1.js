fetch('./func_test_1.wasm').then(response =>
    response.arrayBuffer()
).then(bytes => WebAssembly.instantiate(bytes)).then(results => {
    console.log('Loaded wasm module');
    instance = results.instance;
    console.log('instance', instance);

    let red = 2;
    let black = 1;
    let crowned_red = 6;
    let crowned_black = 5;

    console.log('Calling offset');
    let offset = instance.exports.offsetForPosition(3,4);
    console.log('Offset for 3, 4 is ', offset);

    console.debug('Testing isRed true', instance.exports.isRed(red));
    console.debug('Testing isBlack true', instance.exports.isBlack(black));
    console.debug('Testing isRed false', instance.exports.isRed(black));
    console.debug('Testing isBlack false', instance.exports.isBlack(red));
    console.debug('Testing dethrone red', instance.exports.dethrone(crowned_red));
    console.debug('Testing dethrone black', instance.exports.dethrone(crowned_black));
    console.debug('Testing isCrowned true (black)', instance.exports.isCrowned(crowned_black));
    console.debug('Testing isCrowned true (red)', instance.exports.isCrowned(crowned_red));
});
const fs = require('fs');
const readline  = require('readline');
const events = require('events');


let topics_move = {}
topics_move.topics=[]
topics_move.version=1

async function readfile(){
    let rl = readline.createInterface({
        input: fs.createReadStream("./topic-list.txt")
    })

    let lineCount = 0;

    rl.on('line', (line) => {
        lineCount++
        topics_move.topics.push({"topic":line})
        if (lineCount%5 == 0 && lineCount !=1){
            fs.writeFileSync("./topics-to-move"+lineCount+".json",JSON.stringify(topics_move));
            topics_move.topics=[]
        }


    })

    await events.once(rl, 'close');

    console.log(topics_move)
    return topics_move;

}
let move =  readfile(topics_move)


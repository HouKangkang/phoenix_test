// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "web/static/js/app.js".

// To use Phoenix channels, the first step is to import Socket
// and connect at the socket path in "lib/my_app/endpoint.ex":
import {Socket} from "phoenix"

let user_id = location.search.split('?')[1].split('=')[1]
let socket = new Socket("/socket", {params: {token: user_id}})

socket.connect()

// Now that you are connected, you can join channels with a topic:
// let channel = socket.channel("room:lobby", {})
let user_channel = socket.channel("users_socket:" + user_id)

let chatInput         = document.querySelector("#chat-input")
let messagesContainer = document.querySelector("#messages")

chatInput.addEventListener("keypress", event => {
    if(event.keyCode === 13){
        user_channel.push("new_msg",
            {
                topic: "18+19",
                body: chatInput.value,
                from: user_id,
                type: "text"
            })
        chatInput.value = ""
    }
})

// channel.on("new_msg", payload => {
//     let messageItem = document.createElement("li");
//     messageItem.innerText = `[${Date()}] ${payload.body}`
//     messagesContainer.appendChild(messageItem)
// })

user_channel.on("new_msg", payload => {
    let messageItem = document.createElement("li");
    messageItem.innerHTML =
        `[${Date()}] <br>
        type: ${payload.type} <br>
        topic: ${payload.topic} <br>
        from: ${payload.from} <br>
        body: ${payload.body} <br>`
    messagesContainer.appendChild(messageItem)
})

user_channel.on("offline_msgs", payload => {
    // alert(payload.data)
    let data = payload.data
    for(let item in data) {
        let messageItem = document.createElement("li");
        // alert(JSON.stringify(item))
        messageItem.innerHTML =
            `[${Date()}] <br> 
            type: ${data[item].type} <br>
            topic: ${data[item].topic} <br>
            from: ${data[item].from} <br>
            body: ${data[item].body} <br>`
        messagesContainer.appendChild(messageItem)
    }
})

user_channel.on("history_msgs", payload => {
    // alert(payload.data)
    let data = payload.data
    for(let item in data) {
        let messageItem = document.createElement("li");
        // alert(JSON.stringify(item))
        messageItem.innerHTML =
            `[${Date()}] <br> 
            type: ${data[item].type} <br>
            topic: ${data[item].topic} <br>
            from: ${data[item].from} <br>
            body: ${data[item].body} <br>`
        messagesContainer.appendChild(messageItem)
    }
})


user_channel.on("invited", payload => {
    let messageItem = document.createElement("li");
    messageItem.innerText = `[${Date()}] ${payload.body}`
    messagesContainer.appendChild(messageItem)
})


// channel.join()
//   .receive("ok", resp => { console.log("Joined successfully", resp) })
//   .receive("error", resp => { console.log("Unable to join", resp) })

user_channel.join()
    .receive("ok", resp => { console.log("Joined Users successfully", resp) })
    .receive("error", resp => { console.log("Unable to join users", resp) })

user_channel.push("get_unread_msgs",
    {
        topics: ["18+19"]
    })

user_channel.push("get_history_msgs",
    {
        topic: "18+19",
        latestMsgId: 5,
        limit: 10
    })

export default socket

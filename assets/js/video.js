import Player from "./player"
import { Presence } from "phoenix"

let Video = {
    init( socket, element )
    {
        if ( !element )
        {
            return
        }

        let playerId = element.getAttribute( "data-player-id" )
        let videoId = element.getAttribute( "data-id" )
        socket.connect()
        Player.init(
            element.id,
            playerId,
            () =>
            {
                this.onReady( videoId, socket )
            } )
    },

    onReady( videoId, socket )
    {
        let msgContainer = document.getElementById( "msg-container" )
        let msgInput = document.getElementById( "msg-input" )
        let postButton = document.getElementById( "msg-submit" )
        let userList = document.getElementById( 'user-list' )
        let lastSeenId = 0
        let videoChannel = socket.channel(
            "videos:" + videoId,
            () => { return { last_seen_id: lastSeenId } } )

        let presence = new Presence( videoChannel )

        presence.onSync(
            () =>
            {
                userList.innerHTML = presence.list(
                    ( id, { metas: [ first, ...rest ] } ) =>
                    {
                        let count = rest.length + 1
                        return `<li>${ id }: (${ count })</li>`

                    } ).join( "" )
            } )

        // Start listen to click event
        postButton.addEventListener( "click", e =>
        {
            console.log( "\n\nMESSAGE INPUT: \n" )
            console.log( msgInput )
            // create payload obj with 
            let payload = { body: msgInput.value, at: Player.getCurrentTime() }
            videoChannel.push( "new_annotation", payload )
                .receive( "error", e => console.log( e ) )
            msgInput.value = ""
        } )

        msgContainer.addEventListener( "click", e =>
        {
            e.preventDefault()
            let seconds = e.target.getAttribute( "data-seek" )

            if ( !seconds )
            {
                return
            }
            Player.seekTo( seconds )
        } )

        // on event "new_annotation trigger by click"
        videoChannel.on( "new_annotation", ( resp ) =>
        {
            lastSeenId = resp.id
            this.renderAnnotation( msgContainer, resp )
        } )

        videoChannel.join()
            .receive( "ok", resp =>
            {
                let ids = resp.annotations.map( ann => ann.id )
                if ( ids.length > 0 )
                {
                    lastSeenId = Math.max( ...ids )
                    this.scheduleMessages( msgContainer, resp.annotations )
                }
            } )
            .receive( "error", reason => console.log( "join failed", reason ) )
    },

    esc( str )
    {
        let div = document.createElement( "div" )
        div.appendChild( document.createTextNode( str ) )
        return div.innerHTML
    },

    renderAnnotation( msgContainer, { user, body, at } )
    {
        let template = document.createElement( "div" )
        template.innerHTML =
            `<a href="#" data-seek="${ this.esc( at ) }"> 
                [${ this.formatTime( at ) }]
                <b>${ this.esc( user.username ) }</b>:${ this.esc( body ) }
             </a>`

        msgContainer.appendChild( template )
        msgContainer.scrollTop = msgContainer.scrollHeight
    },

    scheduleMessages( msgContainer, annotations )
    {
        clearTimeout( this.scheduleTimer )
        this.scheduleTimer = setTimeout(
            () =>
            {
                let ctime = Player.getCurrentTime()
                let remaining = this.renderAtTime( annotations, ctime, msgContainer )
                this.scheduleMessages( msgContainer, remaining )
            },
            1000 )
    },

    renderAtTime( annotations, seconds, msgContainer )
    {
        return annotations.filter( ann =>
        {
            if ( ann.at > seconds )
            {
                return true
            }
            else
            {
                this.renderAnnotation( msgContainer, ann )
                return false
            }
        } )
    },

    formatTime( at )
    {
        let date = new Date( null )
        date.setSeconds( at / 1000 )
        return date.toISOString().substr( 14, 5 )
    }

}

export default Video
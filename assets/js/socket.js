// NOTE: The contents of this file will only be executed if
// you uncomment its entry in "assets/js/app.js".
import { Socket } from "phoenix"

let socket = new Socket(
  "/socket",
  {
    params: { token: window.userToken },
    logger: ( kind, msg, data ) =>
    {
      console.log( `${ kind }: ${ msg }`, data )
    }
 
  })

export default socket

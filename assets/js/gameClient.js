import { Socket } from "phoenix"

export default class GameClient {
  constructor(gameId, { onGameUpdate, onJoinError }) {
    this.socket = new Socket("/socket", { params: { token: window.userToken }})
    this.socket.connect();
    this.channel = this.socket.channel(`game:${gameId}`, {});

    this.channel.join()
      .receive("ok", state => onGameUpdate(state))
      .receive("error", resp => onJoinError(resp));

    this.channel.on("game:updated", state => onGameUpdate(state));
  }

  pickCard(cardId) {
    this.channel.push(`game:pick_card:${cardId}`);
  }

  guessNoSet() {
    this.channel.push("game:guess_no_set");
  }
}

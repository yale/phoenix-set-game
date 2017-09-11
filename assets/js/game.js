import $ from 'jquery';
import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import cn from 'classnames';
import throttle from 'lodash.throttle';

import Card from './card';
import { Socket } from "phoenix"

const socket = new Socket("/socket", {params: {token: window.userToken}})
socket.connect();

class Game extends Component {
  state = { initialLoad: true };

  componentDidMount() {
    this.channel = socket.channel(`game:${this.props.id}`, {});

    this.channel.join()
      .receive("ok", resp => this.setState({ ...resp, initialLoad: false }))
      .receive("error", resp => { console.log("Unable to join", resp) });

    this.channel.on("game:updated", game => this.throttleSetState(game));
  }

  throttleSetState = throttle((state) => this.setState(state), 300);

  handleSelectCard = (id) => this.channel.push(`game:pick_card:${id}`);

  handleGuessNoSet = () => {
    if (this.state.any_sets) {
      alert("There is a set!");
      return;
    }

    this.channel.push("game:guess_no_set");
  }

  render() {
    if (this.state.initialLoad) {
      return <div className="loading">Loading...</div>;
    }

    const className = cn("game", { isSet: this.state.is_set, gameOver: this.state.game_over });

    return <div className={className}>
      <div className="game-table">
        {
          this.state.table.map((card, i) => (
            card ?
              <Card key={card.id} onSelect={this.handleSelectCard} {...card} /> :
              <Card blank key={`blank-${i}`} />
          ))
        }
      </div>
      <div className="game-actions">
      {
        this.state.game_over ?
          <a href="/game/new" className="btn btn-lg btn-success">New Game?</a> :
          <a onClick={this.handleGuessNoSet} className="btn btn-lg btn-danger">No Set</a>
      }
      </div>
    </div>;
  }
}

$(() => {
  const gameEl = document.getElementById("game");
  const gameId = gameEl.dataset.id;

  ReactDOM.render(
    <Game id={gameId} />,
    gameEl,
  );
});

import $ from 'jquery';
import React, { Component } from 'react';
import ReactDOM from 'react-dom';
import cn from 'classnames';
import throttle from 'lodash.throttle';

import Card from './card';
import GameClient from './gameClient';

class Game extends Component {
  state = { initialLoad: true };

  componentDidMount() {
    this.client = new GameClient(this.props.id, {
      onGameUpdate: this.handleGameUpdate,
      onJoinError: this.handleJoinError,
    });
  }

  throttleSetState = throttle((state) => this.setState(state), 150);

  handleJoinError = resp => console.error("Unable to join", resp);
  handleGameUpdate = state => {
    console.log(state);
    this.throttleSetState({ ...state, initialLoad: false });
  }
  handleSelectCard = (id) => this.client.pickCard(id);

  handleGuessNoSet = () => {
    if (this.state.any_sets) {
      alert("There is a set!");
      return;
    }

    this.client.guessNoSet();
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

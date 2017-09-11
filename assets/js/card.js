import React, { Component } from 'react';
import cn from 'classnames';
import times from 'lodash.times';

export default class Card extends Component {
  state = { initial: true }

  componentDidMount() {
    setTimeout(() => {
      this.setState({ initial: false });
    }, 10);
  }

  render() {
    if (this.props.blank) {
      return <div className="card"></div>;
    }

    const { id, color, number, shape, shading, selected, onSelect } = this.props;
    const { initial } = this.state;
    const className = cn("card", color, shape, shading, { selected, initial });

    return <div onClick={() => onSelect(id)} className={className} id={id}>
      {
        times(number, (i) => <div key={`${id}-${i}`} className="shape">
          <div className="inner"></div>
        </div>)
      }
    </div>;
  }
}

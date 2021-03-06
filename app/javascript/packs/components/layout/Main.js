import React from 'react'
import { Switch, Route } from 'react-router-dom'

import Home from '../../pages/Home'
import Send from '../../pages/Send'

const Main = () => (
  <main>
    <div className="container">
      <Switch>
        <Route exact path='/' component={Home}/>
        <Route path='/send' component={Send}/>
      </Switch>
    </div>
  </main>
);

export default Main

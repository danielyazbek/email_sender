import React from 'react'
import { Link, NavLink } from 'react-router-dom'

const Header = () => (
  <header>
    <nav className="navbar navbar-expand-lg navbar-light bg-light" role="navigation">
      <Link class="navbar-brand" to="/">EmailSender</Link>
      <button className="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav"
              aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
        <span className="navbar-toggler-icon"></span>
      </button>
      <div className="collapse navbar-collapse" id="navbarNav">
        <ul className="navbar-nav">
          <li className={"nav-item "}>
            <NavLink to="send" class="nav-link" activeClassName="active">Send Mail</NavLink>
          </li>
        </ul>
      </div>
    </nav>
  </header>
);

export default Header

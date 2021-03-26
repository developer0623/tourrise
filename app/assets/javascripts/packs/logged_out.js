import "../../stylesheets/logged_out.scss";
import { Application } from "stimulus"
import { definitionsFromContext } from "stimulus/webpack-helpers"

require("@hotwired/turbo-rails")

const application = Application.start()
const context = require.context("../controllers", true, /\.js$/)
application.load(definitionsFromContext(context))

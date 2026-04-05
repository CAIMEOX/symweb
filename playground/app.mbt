///|
using @html {
  button,
  div,
  h2,
  header,
  nothing,
  p,
  pre,
  section,
  small,
  span,
  textarea,
}

///|
fn nav_button_class(active : Bool) -> String {
  if active {
    "nav-button nav-button-active"
  } else {
    "nav-button"
  }
}

///|
fn function_button_class(active : Bool) -> String {
  if active {
    "function-button function-button-active"
  } else {
    "function-button"
  }
}

///|
fn example_button_class(active : Bool) -> String {
  if active {
    "example-button example-button-active"
  } else {
    "example-button"
  }
}

///|
fn parser_button_class(active : Bool) -> String {
  if active {
    "parser-button parser-button-active"
  } else {
    "parser-button"
  }
}

///|
fn tree_button_class(active : Bool) -> String {
  if active {
    "tree-function-button tree-function-button-active"
  } else {
    "tree-function-button"
  }
}

///|
fn result_card(
  label_text : String,
  value : String,
  latex : String?,
) -> @html.Html {
  let rendered_value = match latex {
    Some(source) =>
      div(class="result-value-latex-shell", [
        pre(class="result-value latex-fallback", value),
        pre(class="latex-source", source),
        div(class="latex-render", nothing),
      ])
    None => pre(class="result-value", value)
  }
  div(class="result-card", [p(class="result-label", label_text), rendered_value])
}

///|
fn visible_result_fields(
  model : DocModel,
  result : EvalResult,
) -> Array[ResultField] {
  let visible_fields : Array[ResultField] = []
  for field in result.fields {
    if model.show_structural_form || field.label != "Structural Form" {
      visible_fields.push(field)
    }
  }
  visible_fields
}

///|
fn result_grid_class(field_count : Int) -> String {
  if field_count >= 3 {
    "result-grid result-grid-3"
  } else {
    "result-grid result-grid-2"
  }
}

///|
fn package_is_expanded(model : DocModel, pkg : DocPackage) -> Bool {
  for item in model.expanded_packages {
    if item == pkg {
      return true
    }
  }
  false
}

///|
fn tree_function_button(
  dispatch : @rabbita.Dispatch[DocMsg],
  model : DocModel,
  doc : FunctionDoc,
) -> @html.Html {
  button(
    class=tree_button_class(model.active_function == doc.id),
    type_="button",
    title=doc.summary,
    on_click=dispatch(DocMsg::SelectFunction(doc.id)),
    [span(class="tree-function-name", doc.label)],
  )
}

///|
fn package_button(
  dispatch : @rabbita.Dispatch[DocMsg],
  model : DocModel,
  doc : PackageDoc,
) -> @html.Html {
  let expanded = package_is_expanded(model, doc.id)
  div(class="nav-node", [
    button(
      class=nav_button_class(model.active_package == doc.id),
      type_="button",
      on_click=dispatch(DocMsg::TogglePackageNode(doc.id)),
      [
        div(class="nav-title-row", [
          span(class="nav-chevron", if expanded { "−" } else { "+" }),
          span(class="nav-title", doc.label),
        ]),
      ],
    ),
    if expanded {
      div(
        class="nav-children",
        function_catalog(doc.id).map(fn(fn_doc) {
          tree_function_button(dispatch, model, fn_doc)
        }),
      )
    } else {
      div(class="nav-children-hidden", nothing)
    },
  ])
}

///|
fn example_button(
  dispatch : @rabbita.Dispatch[DocMsg],
  model : DocModel,
  item : FunctionExample,
) -> @html.Html {
  button(
    class=example_button_class(model.active_example == item.id),
    type_="button",
    title=item.description,
    on_click=dispatch(DocMsg::SelectExample(item.id)),
    [
      span(class="example-title", item.label),
      small(class="example-copy", item.description),
    ],
  )
}

///|
fn parser_button(
  dispatch : @rabbita.Dispatch[DocMsg],
  model : DocModel,
  toggle : ParserToggle,
) -> @html.Html {
  let active = parser_toggle_value(model.parser, toggle)
  button(
    class=parser_button_class(active),
    type_="button",
    title=parser_toggle_help(toggle),
    on_click=dispatch(DocMsg::ToggleParser(toggle)),
    [
      span(class="parser-state", if active { "on" } else { "off" }),
      span(class="parser-copy", parser_toggle_label(toggle)),
    ],
  )
}

///|
fn result_panel(model : DocModel) -> @html.Html {
  match model.result {
    EvalState::Failure(message) =>
      section(class="panel panel-danger", [
        h2("Output"),
        pre(class="error-block", message),
      ])
    EvalState::Success(result) => {
      let visible_fields = visible_result_fields(model, result)
      section(class="panel", [
        h2("Output"),
        div(
          class=result_grid_class(visible_fields.length()),
          visible_fields.map(field => {
            result_card(field.label, field.value, field.latex)
          }),
        ),
      ])
    }
  }
}

///|
fn settings_modal(
  dispatch : @rabbita.Dispatch[DocMsg],
  model : DocModel,
) -> @html.Html {
  if !model.settings_open {
    return div(class="settings-modal-hidden", nothing)
  }
  div(class="settings-backdrop", [
    div(class="settings-dialog panel", [
      div(class="settings-header", [
        h2("Settings"),
        button(
          class="settings-close-button",
          type_="button",
          on_click=dispatch(DocMsg::CloseSettings),
          "Close",
        ),
      ]),
      div(class="settings-section", [
        h2("Display"),
        button(
          class=parser_button_class(model.show_structural_form),
          type_="button",
          on_click=dispatch(DocMsg::ToggleStructuralFormDisplay),
          [
            span(
              class="parser-state",
              if model.show_structural_form {
                "on"
              } else {
                "off"
              },
            ),
            span(class="parser-copy", "Show Structural Form"),
          ],
        ),
      ]),
      div(
        class="parser-grid settings-parser-grid",
        parser_toggle_catalog().map(toggle => {
          parser_button(dispatch, model, toggle)
        }),
      ),
    ]),
  ])
}

///|
fn view(dispatch : @rabbita.Dispatch[DocMsg], model : DocModel) -> @html.Html {
  let function_ref = function_doc(model.active_function)
  let active_example = example_source_or_default(
    model.active_function,
    model.active_example,
  )
  div(class="reference-shell", [
    header(class="topbar", [
      p(class="topbar-brand", "symbit"),
      div(class="topbar-actions", [
        button(
          class="topbar-button",
          type_="button",
          on_click=dispatch(DocMsg::OpenSettings),
          "Settings",
        ),
      ]),
    ]),
    div(class="reference-layout", [
      div(class="sidebar", [
        section(class="panel sidebar-panel", [
          h2("Packages"),
          div(
            class="nav-stack",
            package_catalog().map(doc => package_button(dispatch, model, doc)),
          ),
        ]),
      ]),
      div(class="content-column", [
        section(class="panel examples-panel", [
          h2(function_ref.label),
          p(class="function-signature-line", function_ref.signature),
          div(
            class="example-grid",
            function_ref.examples.map(item => {
              example_button(dispatch, model, item)
            }),
          ),
        ]),
        section(class="panel runner-panel", [
          h2("Source"),
          textarea(
            id="doc-source",
            class="editor-area",
            value=model.draft_source,
            rows=12,
            placeholder=active_example.source,
            on_input=s => dispatch(DocMsg::UpdateDraft(s)),
            nothing,
          ),
          p(class="example-description", active_example.description),
        ]),
        result_panel(model),
      ]),
    ]),
    settings_modal(dispatch, model),
  ])
}

///|
fn update(
  dispatch : @rabbita.Dispatch[DocMsg],
  msg : DocMsg,
  model : DocModel,
) -> (@rabbita.Cmd, DocModel) {
  match msg {
    DocMsg::UpdateDraft(source) => {
      let next_revision = model.draft_revision + 1
      (
        @rabbita.delay(
          dispatch(DocMsg::DebouncedRun(next_revision)),
          debounce_ms(),
        ),
        {
          ..model,
          draft_source: source,
          dirty: true,
          draft_revision: next_revision,
        },
      )
    }
    DocMsg::CheckKernelReady =>
      match wasm_kernel_status() {
        "loading" =>
          (@rabbita.delay(dispatch(DocMsg::CheckKernelReady), kernel_poll_ms()), model)
        _ => (@rabbita.none, recompute_model(model))
      }
    DocMsg::OpenSettings => (@rabbita.none, { ..model, settings_open: true })
    DocMsg::CloseSettings => (@rabbita.none, { ..model, settings_open: false })
    DocMsg::ToggleStructuralFormDisplay =>
      (
        @rabbita.none,
        { ..model, show_structural_form: !model.show_structural_form },
      )
    DocMsg::TogglePackageNode(pkg) => {
      let expanded_packages : Array[DocPackage] = []
      let mut was_expanded = false
      for item in model.expanded_packages {
        if item == pkg {
          was_expanded = true
        } else {
          expanded_packages.push(item)
        }
      }
      if was_expanded {
        (
          @rabbita.none,
          {
            ..model,
            active_package: pkg,
            expanded_packages,
            settings_open: false,
          },
        )
      } else {
        expanded_packages.push(pkg)
        let next = model_for_function(model, default_function(pkg))
        (@rabbita.none, { ..next, expanded_packages, settings_open: false })
      }
    }
    DocMsg::DebouncedRun(revision) =>
      if revision == model.draft_revision && model.dirty {
        (@rabbita.none, recompute_model(model))
      } else {
        (@rabbita.none, model)
      }
    DocMsg::SelectPackage(pkg) => {
      let function_id = default_function(pkg)
      let example = default_example(function_id)
      (
        @rabbita.none,
        recompute_model({
          ..model,
          active_package: pkg,
          active_function: function_id,
          expanded_packages: if package_is_expanded(model, pkg) {
            model.expanded_packages
          } else {
            model.expanded_packages + [pkg]
          },
          active_example: example.id,
          draft_source: example.source,
          draft_revision: model.draft_revision + 1,
          settings_open: false,
        }),
      )
    }
    DocMsg::SelectFunction(function_id) =>
      (
        @rabbita.none,
        {
          ..model_for_function(model, function_id),
          expanded_packages: if package_is_expanded(
              model,
              function_doc(function_id).package_id,
            ) {
            model.expanded_packages
          } else {
            model.expanded_packages + [function_doc(function_id).package_id]
          },
          settings_open: false,
        },
      )
    DocMsg::SelectExample(id) =>
      match example_by_id(model.active_function, id) {
        Some(item) =>
          (
            @rabbita.none,
            recompute_model({
              ..model,
              active_example: item.id,
              draft_source: item.source,
              draft_revision: model.draft_revision + 1,
              settings_open: false,
            }),
          )
        None => (@rabbita.none, model)
      }
    DocMsg::ToggleParser(toggle) =>
      (
        @rabbita.none,
        recompute_model({
          ..model,
          parser: toggle_parser_setting(model.parser, toggle),
        }),
      )
  }
}

///|
pub fn algebra_app() -> @rabbita.Cell {
  @rabbita.cell(model=default_model(), update~, view~)
}

///|
#cfg(target="js")
pub fn algebra_web_app() -> @rabbita.App {
  let (dispatch, cell) = @rabbita.cell_with_dispatch(model=default_model(), update~, view~)
  let app = @rabbita.new(cell)
  app.with_init(dispatch(DocMsg::CheckKernelReady))
  app
}

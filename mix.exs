defmodule GenStatem.MixProject do
  use Mix.Project

  @version "0.1.0"

  def project do
    [
      app: :gen_statem,
      version: @version,
      elixir: "~> 1.18",
      start_permanent: Mix.env() == :prod,
      aliases: aliases(),
      deps: deps(),
      description: description(),
      package: package(),
      source_url: "https://github.com/gilbertwong96/gen_statem",
      test_coverage: [tool: ExCoveralls],
      preferred_cli_env: [
        coveralls: :test,
        "coveralls.detail": :test,
        "coveralls.post": :test,
        "coveralls.html": :test,
        "coveralls.cobertura": :test
      ],
      docs: [
        main: "GenStatem",
        extras: ["README.md"],
        source_ref: "v#{@version}",
        before_closing_head_tag: &before_closing_head_tag/1
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:ex_doc, "~> 0.38", only: :dev, runtime: false},
      {:dialyxir, "~> 1.4", only: :dev, runtime: false},
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:mix_audit, "~> 2.1", only: [:dev, :test], runtime: false},
      {:mix_test_watch, "~> 1.2", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.16", only: :test}
    ]
  end

  defp description do
    "An Elixir implementation of gen_statem."
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Gilbert Wong"],
      licenses: ["Apache 2.0"],
      links: %{
        "GitHub" => "https://github.com/gilbertwong96/gen_statem",
        "Changelog" => "https://github.com/gilbertwong96/gen_statem/blob/main/CHANGELOG.md",
        "Issues" => "https://github.com/gilbertwong96/gen_statem/issues"
      },
      description: "An Elixir implementation of gen_statem with enhanced features and ergonomics"
    ]
  end

  defp aliases do
    [
      ci: [
        "compile --all-warnings --warnings-as-errors",
        "format --check-formatted",
        "credo --strict",
        "deps.audit",
        "xref graph --label compile-connected --fail-above 0",
        "dialyzer"
      ]
    ]
  end

  defp before_closing_head_tag(:epub), do: ""

  defp before_closing_head_tag(:html) do
    """
    <script defer src="https://cdn.jsdelivr.net/npm/mermaid@10.2.3/dist/mermaid.min.js"></script>
    <script>
      let initialized = false;

      window.addEventListener("exdoc:loaded", () => {
        if (!initialized) {
          mermaid.initialize({
            startOnLoad: false,
            theme: document.body.className.includes("dark") ? "dark" : "default"
          });
          initialized = true;
        }

        let id = 0;
        for (const codeEl of document.querySelectorAll("pre code.mermaid")) {
          const preEl = codeEl.parentElement;
          const graphDefinition = codeEl.textContent;
          const graphEl = document.createElement("div");
          const graphId = "mermaid-graph-" + id++;
          mermaid.render(graphId, graphDefinition).then(({svg, bindFunctions}) => {
            graphEl.innerHTML = svg;
            bindFunctions?.(graphEl);
            preEl.insertAdjacentElement("afterend", graphEl);
            preEl.remove();
          });
        }
      });
    </script>
    """
  end
end

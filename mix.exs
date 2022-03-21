defmodule SuperTest.MixProject do
  use Mix.Project

  def project do
    [
      app: :super_test,
      version: "0.1.0",
      elixir: "~> 1.12",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  def application do
    [
      extra_applications: [:logger],
      mod: {SuperTest.Application, []}
    ]
  end

  defp deps do
    [
      {:libcluster, "~> 3.3"},
      {:horde, git: "https://github.com/dtykocki/horde", branch: "add-debug-logging"}
    ]
  end
end

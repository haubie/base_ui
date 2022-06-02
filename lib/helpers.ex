defmodule BaseUI.Helpers do

  def static_file(file_name), do: Path.join(:code.priv_dir(:base_ui), file_name)

  def css_file, do: static_file("app.css")

end

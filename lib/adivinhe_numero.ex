defmodule AdivinheNumero do
  use Application

  def start(_,_) do
    run()
    {:ok, self()}
  end

  def run() do
    IO.puts("Vamos jogar Adivinhe o Número")

    IO.gets("Escolha o nível de dificuldade (1, 2 ou 3): ")
    |> parse_input()
    |> pickup_number()
    |> play()
  end

  def pickup_number(level) do
    level
    |> get_range()
    |> Enum.random()
  end

  def play(picked_num) do
    IO.gets("[Computador] Eu escolhi um número. Qual número eu escolhi? ")
    |> parse_input()
    |> adivinhe_numero(picked_num, 1)
  end

  # Utilização de Guards
  def adivinhe_numero(usr_adivinhe_numero, picked_num, count) when usr_adivinhe_numero > picked_num do
    IO.gets("[Computador] Muito alto. Tente novamente: ")
    |> parse_input()
    |> adivinhe_numero(picked_num, count + 1)
  end

  # Utilização de Guards
  def adivinhe_numero(usr_adivinhe_numero, picked_num, count) when usr_adivinhe_numero < picked_num do
    IO.gets("[Computador] Muito baixo. Tente novamente: ")
    |> parse_input()
    |> adivinhe_numero(picked_num, count + 1)
  end

  def adivinhe_numero(_usr_adivinhe_numero, _picked_num, count) do
    IO.puts("[Computador] Você acertou em #{count} tentativa(s)!")
    show_score(count)
  end

  # Utilização de Guards
  def show_score(tries) when tries > 6 do
    IO.puts("[Computador] Mais de 6 tentativas... Mais sorte na próxima.")
  end

  def show_score(tries) do
    {_, msg} = %{1..1 => "Acertou de primeira!!!",
      2..4 => "Boa!",
      5..6 => "Você pode fazer melhor do que isso."}
      # _ => "Mais sorte na próxima."}
      # Percorre os elementos no map acima
      |> Enum.find(fn {range, _} ->
        # Verifica se o valor de tries faz parte de um dos itens de range
        Enum.member?(range, tries)
      end)
    IO.puts("[Computador] #{msg}")
  end

  def parse_input(:error) do
      IO.puts("[Computador] Opa, opção inválida!")
      run()
  end

  def parse_input({num, _}), do: num

  def parse_input(data) do
    data
    |> Integer.parse()
    |> parse_input()
  end

  def get_range(level) do
    case level do
      1 -> 1..10
      2 -> 1..100
      3 -> 1..1000
      _ -> IO.puts("[Computador] Opa, nível inválido!")
        run()
    end
  end
end

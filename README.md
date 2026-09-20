# Quantfolio Lab

An end-to-end Python quantitative research platform for market-data ingestion, technical-factor computation, rule-based strategy research, backtesting, risk sizing, REST APIs, and an interactive Streamlit dashboard.

> Portfolio-project goal: demonstrate software engineering + quantitative research workflow without requiring a brokerage account or private API credentials.

## What it does

- Loads market data from deterministic local demo data or Yahoo Finance when enabled.
- Computes SMA, EMA, RSI, ATR, and rolling volatility features.
- Generates long/flat signals with a configurable moving-average crossover strategy.
- Runs a vectorized daily backtest with transaction costs and position changes.
- Calculates return, annualized return, Sharpe ratio, max drawdown, volatility, and trade statistics.
- Includes volatility-aware risk sizing based on a stop distance and portfolio risk budget.
- Exposes research results through FastAPI.
- Provides a Streamlit dashboard for interactive research.
- Ships with pytest coverage for data, indicators, strategy, backtest, risk, and API behavior.
- Includes Docker and GitHub Actions CI configuration.

## Architecture

```text
                         +-----------------------+
                         |   Streamlit Dashboard |
                         +-----------+-----------+
                                     |
                                     v
+-------------+      +--------------+--------------+      +----------------+
| Demo / Yahoo| ---> | Data + Features + Strategy | ---> | Backtest Engine|
| Data Source |      +--------------+--------------+      +--------+-------+
+-------------+                     |                            |
                                    v                            v
                             +------+-------+              +-----+------+
                             |  Risk Engine |              |   Metrics  |
                             +--------------+              +------------+
                                    ^
                                    |
                              +-----+-----+
                              |  FastAPI  |
                              +-----------+
```

See [`docs/architecture.md`](docs/architecture.md) for a more detailed design.

## Tech stack

Python 3.12, pandas, NumPy, FastAPI, Pydantic, Streamlit, Plotly, pytest.

## Quick start on Windows PowerShell

```powershell
py -3.12 -m venv .venv
.\.venv\Scripts\Activate.ps1
python -m pip install --upgrade pip
pip install -r requirements.txt

# Run tests
pytest -q

# Start the API
python -m uvicorn quantfolio.api.main:app --reload

# In another PowerShell window, start the dashboard
streamlit run src/quantfolio/app.py
```

Dashboard: `http://localhost:8501`
API docs: `http://127.0.0.1:8000/docs`

## Optional Yahoo Finance data

The platform works with local deterministic data by default. To fetch a real ticker, set `QUANTFOLIO_DATA_SOURCE=yahoo` and install the optional provider dependency already included in `requirements.txt`.

```powershell
$env:QUANTFOLIO_DATA_SOURCE="yahoo"
streamlit run src/quantfolio/app.py
```

The dashboard deliberately falls back to demo data if remote data cannot be fetched, so the project remains runnable offline.

## API examples

Health check:

```text
GET /health
```

Backtest a symbol with defaults:

```text
GET /backtest/AAPL
```

Backtest with configurable strategy parameters:

```text
GET /backtest/AAPL?fast_window=20&slow_window=50&initial_capital=10000&transaction_cost_bps=5
```

Generate the latest signal snapshot:

```text
GET /signals/AAPL?fast_window=20&slow_window=50
```

## Example project flow

1. Select an instrument and research period.
2. Ingest OHLCV data.
3. Add technical features.
4. Generate a deterministic strategy signal.
5. Run the backtest with costs.
6. Evaluate risk-adjusted performance.
7. Inspect equity curve, drawdowns, and trades.
8. Use the same research logic through REST endpoints.

## Why this is a useful portfolio project

The repository is structured as a production-style research codebase rather than a single notebook. It demonstrates separation of concerns, testable domain logic, API design, data-provider abstraction, reproducible demo data, and a user-facing interface.

## Validation status

The repository includes 12 automated tests covering data validation, indicators, strategy behavior, backtesting, risk sizing, and API endpoints. The test suite passes in the development environment used to assemble this repository.

## Limitations

This is a research/education project, not a broker-connected trading system. Backtests can suffer from look-ahead bias, survivorship bias, unrealistic fills, data quality issues, and parameter overfitting. The included strategy is intentionally simple so that the engineering pipeline remains easy to inspect.

## License

MIT

abstract class PortfolioState {}

class PortfolioInitial extends PortfolioState {}

class PortfolioLoading extends PortfolioState {}

class PortfolioSuccess extends PortfolioState {}

class PortfolioError extends PortfolioState {
  final String message;
  PortfolioError(this.message);
}

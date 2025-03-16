import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/utils/logger.dart';
import '../../../authentication/presentation/bloc/auth_bloc.dart';
import '../../../home/domain/entities/get_event_entite.dart';
import '../../domain/entities/payment_session_entity.dart';
import '../../domain/usecases/create_payment_session_usecase.dart';
import '../../domain/usecases/process_payment_usecase.dart';
import 'payment_event.dart';
import 'payment_state.dart';
import '../../../authentication/presentation/bloc/auth_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final CreatePaymentSessionUseCase createPaymentSessionUseCase;
  final ProcessPaymentUseCase processPaymentUseCase;
  final AuthBloc authBloc;

  PaymentBloc({
    required this.createPaymentSessionUseCase,
    required this.processPaymentUseCase,
    required this.authBloc,
  }) : super(PaymentInitial()) {
    on<InitializePaymentEvent>(_onInitializePayment);
    on<CreatePaymentSessionEvent>(_onCreatePaymentSession);
    on<ProcessPaymentEvent>(_onProcessPayment);
  }

  Future<void> _onInitializePayment(
    InitializePaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      Logger.debug('Initializing payment with args: ${event.args}');
      emit(PaymentLoading());

      final args = event.args;
      final eventData = args['event'] as GetAllEventEntities;
      final ticketCount = args['ticketCount'] as int;

      Logger.debug('Creating payment session for event: ${eventData.title}');
      Logger.debug('Ticket count: $ticketCount');

      final session = PaymentSessionEntity(
        username: (authBloc.state is AuthSuccess)
            ? (authBloc.state as AuthSuccess).userEntity.username
            : 'user',
        eventId: eventData.id.toString(),
        hosterId: eventData.hostId.toString(),
        title: eventData.title,
        price: eventData.ticketPrice.toString(),
        quantity: ticketCount.toString(),
      );

      Logger.debug('Calling payment session creation with data: $session');
      final response = await createPaymentSessionUseCase(session);
      Logger.debug(
          'Payment session created successfully: ${response.sessionId}');

      emit(PaymentInitialized(
        event: eventData,
        ticketCount: ticketCount,
        sessionDetails: response,
      ));
    } catch (e, stackTrace) {
      Logger.error('Payment initialization failed:', e);
      Logger.error('Stack trace:', stackTrace);
      emit(PaymentError('Failed to initialize payment: ${e.toString()}'));
    }
  }

  Future<void> _onCreatePaymentSession(
    CreatePaymentSessionEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      Logger.debug('Creating payment session with data: ${event.session}');
      emit(PaymentLoading());
      final response = await createPaymentSessionUseCase(event.session);
      Logger.debug('Payment session created: ${response.sessionId}');
      emit(PaymentSuccess(response: response));
    } catch (e, stackTrace) {
      Logger.error('Payment session creation failed:', e);
      Logger.error('Stack trace:', stackTrace);
      emit(PaymentError('Failed to create payment session: ${e.toString()}'));
    }
  }

  Future<void> _onProcessPayment(
    ProcessPaymentEvent event,
    Emitter<PaymentState> emit,
  ) async {
    try {
      Logger.debug(
          'Processing payment with intent ID: ${event.paymentIntentId}');
      emit(PaymentLoading());
      final response = await processPaymentUseCase(event.paymentIntentId);
      Logger.debug('Payment processed successfully: ${response.status}');
      emit(PaymentSuccess(response: response));
    } catch (e, stackTrace) {
      Logger.error('Payment processing failed:', e);
      Logger.error('Stack trace:', stackTrace);
      emit(PaymentError('Failed to process payment: ${e.toString()}'));
    }
  }
}

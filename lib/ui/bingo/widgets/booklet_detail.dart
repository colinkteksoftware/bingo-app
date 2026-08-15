import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/ui/bingo/bloc/bingo_bloc.dart';
import 'package:bingo/ui/bingo/bloc/bingo_event.dart';
import 'package:bingo/ui/bingo/bloc/bingo_state.dart';
import 'package:bingo/ui/bingo/widgets/booklet_nofound.dart';
import 'package:bingo/ui/bingo/widgets/game_type_widget.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

class BookletDetailPage extends StatefulWidget {
  const BookletDetailPage({super.key});

  @override
  State<BookletDetailPage> createState() => _BookletDetailPageState();
}

class _BookletDetailPageState extends State<BookletDetailPage> {
  final TextEditingController _controller = TextEditingController(text: "0");
  late final GameTypeBloc _gameTypeBloc;

  @override
  void initState() {
    super.initState();
    _gameTypeBloc = GameTypeBloc();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BingoProvider>(context, listen: false);
      //provider.clearBooklet();
      if ((provider.bingo.bingoId ?? 0) != 0 && provider.qrcode.isNotEmpty) {
        await provider.fetchShowscartilla(context);
      }
    });
  }

  @override
  void dispose() {
    _gameTypeBloc.close();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<BingoProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.40,
                        child: Column(
                          children: [
                            Consumer<BingoProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(
                                          color: primaryBlue),
                                    ),
                                  );
                                } else if (provider.infoBooklet.isEmpty) {
                                  return const BookletNoFound();
                                } else {
                                  return Column(
                                    children: [
                                      moduleWidget(provider.qrcode),
                                      itemBookletWidget(size, provider),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            //gameTypeWidget(provider, size),
            Padding(
              padding: const EdgeInsets.all(16),
              child: BlocProvider.value(
                value: _gameTypeBloc,
                child: BlocListener<GameTypeBloc, GameTypeState>(
                  listenWhen: (previous, current) =>
                      previous.counter != current.counter ||
                      previous.aditional != current.aditional,
                  listener: (context, state) {
                    final bingoProvider =
                        Provider.of<BingoProvider>(context, listen: false);

                    if (bingoProvider.aditional != state.aditional) {
                      bingoProvider.updateaditional(state.aditional);
                    }

                    if (state.aditional == 2) {
                      if (bingoProvider.counter != state.counter) {
                        bingoProvider.updateCounter(state.counter);
                      }
                    } else if (bingoProvider.counter != 1) {
                      bingoProvider.updateCounter(1);
                    }

                    // Actualiza el TextEditingController solo si es diferente
                    if (_controller.text != state.counter.toString()) {
                      _controller.text = state.counter.toString();
                    }
                  },
                  child: BlocBuilder<GameTypeBloc, GameTypeState>(
                    builder: (context, state) {
                      return GameTypeWidget(
                        aditional: state.aditional,
                        counter: state.counter,
                        onTypeSelected: (value) {
                          context
                              .read<GameTypeBloc>()
                              .add(SelectAditional(value));
                        },
                        onIncrement: () {
                          context.read<GameTypeBloc>().add(IncrementCounter());
                        },
                        onDecrement: () {
                          context.read<GameTypeBloc>().add(DecrementCounter());
                        },
                        onCounterChanged: (value) {
                          context
                              .read<GameTypeBloc>()
                              .add(ChangeCounter(value));
                        },
                        counterController: _controller,
                      );
                    },
                  ),
                ),
              ),
            ),
            /*Padding(
              padding: const EdgeInsets.all(16),
              child: BlocBuilder<GameTypeBloc, GameTypeState>(
                builder: (context, state) {
                  return GameTypeWidget(
                    aditional: state.aditional,
                    counter: state.counter,
                    onTypeSelected: (value) {
                      context.read<GameTypeBloc>().add(SelectAditional(value));
                    },
                    onIncrement: () {
                      context.read<GameTypeBloc>().add(IncrementCounter());
                    },
                    onDecrement: () {
                      context.read<GameTypeBloc>().add(DecrementCounter());
                    },
                    onCounterChanged: (value) {
                      context.read<GameTypeBloc>().add(ChangeCounter(value));
                    },
                    counterController: _controller,
                  );
                },
              ),
            ),*/
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Consumer<BingoProvider>(
                    builder: (context, provider, child) {
                      return AnimatedButton(
                        color: provider.isLoading ? Colors.grey : primaryBlue,
                        height: size.height * 0.05,
                        width: size.width * 0.4,
                        duration: 2,
                        onPressed: () async {
                          if (!provider.isLoading) {
                            final uiState = _gameTypeBloc.state;
                            final int currentAditional = uiState.aditional;
                            final int currentCounter = uiState.counter < 1 ? 1 : uiState.counter;

                            if (provider.bingo.estado == 3) {
                              showAlerta(context, 'Mensaje Informativo',
                                  'El bingo ya se ha finalizado');
                            } else {
                              final hasSelectedBooklets = provider.infoBooklet
                                  .any((booklet) => booklet.estado == true);
                              if (!hasSelectedBooklets) {
                                showAlerta(context, 'Mensaje Informativo',
                                    'Para ventas debes seleccionar una cartilla.');
                              } else {
                                if (currentAditional == 2 &&
                                    currentCounter > 1) {
                                  openAlertBox(
                                    context,
                                    provider,
                                    currentAditional,
                                    currentCounter,
                                  );
                                } else {
                                  await provider.registerSale(
                                    context,
                                    forcedAditional: currentAditional,
                                    forcedCounter: currentCounter,
                                  );
                                }
                              }
                            }
                          }
                        },
                        child: Center(
                          child: provider.isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        primaryBlue),
                                  ),
                                )
                              : Text(
                                  'Valor venta: ${moneyFormatted(double.parse(provider.preciofinal.toString()))}',
                                  style: TextStyle(
                                    color: const Color(0xFFcaf0f8),
                                    fontSize: size.width * 0.034,
                                    fontFamily: 'gotic',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center gameTypeWidget(BingoProvider provider, Size size) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              provider.updateaditional(0);
              provider.calculeTotal();
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 0 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 0
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 0
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Normal",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateaditional(1);
              provider.calculeTotal();
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 1 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 1
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 1
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Promocional",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateaditional(2);
              provider.updateCounter(1);
              provider.calculeTotal();
              setState(() {
                _controller.text = provider.counter.toString();
              });
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 2 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 2
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 2
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Progresivo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          provider.aditional == 2
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.amber),
                      onPressed: () {
                        provider.decrement();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.14,
                      child: Consumer<BingoProvider>(
                        builder: (context, provider, _) {
                          return SizedBox(
                            width: size.width * 0.14,
                            child: TextFormField(
                              controller: provider.counterController,
                              keyboardType: TextInputType.number,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: size.width * 0.034,
                                fontFamily: 'gotic',
                                fontWeight: FontWeight.bold,
                              ),
                              decoration: InputDecoration(
                                labelText: 'Cantidad',
                                border: const OutlineInputBorder(),
                                labelStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.020,
                                  fontFamily: 'gotic',
                                  fontWeight: FontWeight.bold,
                                ),
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: size.width * 0.034,
                                  fontFamily: 'gotic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  final newValue = int.tryParse(value);
                                  if (newValue != null && newValue >= 0) {
                                    provider.updateCounter(newValue);
                                  }
                                }
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.amber),
                      onPressed: () {
                        provider.increment();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  SizedBox itemBookletWidget(Size size, BingoProvider provider) {
    return SizedBox(
      height: size.height * 0.32,
      child: ListView.builder(
        itemCount: provider.infoBooklet.length,
        itemBuilder: (context, index) {
          final infoBooklet = provider.infoBooklet[index];
          return bookletWidget(infoBooklet);
        },
      ),
    );
  }

  Widget moduleWidget(String codigo) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
        border: Border.all(color: const Color(0xFF1b6b93), width: 1.0),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('MODULO $codigo',
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: Colors.white,
                fontFamily: 'gotic',
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget bookletWidget(Booklet cartilla) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<BingoProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.only(left: 10),
      width: size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
        border: Border.all(color: const Color(0xFF1b6b93), width: 1.0),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            cartilla.quantity == 1
                ? "Cartilla: ${cartilla.cartillaId}${" - SI".toUpperCase()}"
                : "Cartilla: ${cartilla.cartillaId}${" - NO".toUpperCase()}",
            style: TextStyle(
              fontSize: size.width * 0.05,
              color: Colors.white,
              fontFamily: 'gotic',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: size.width * 0.34,
            child: Center(
              child: SwitchListTile(
                controlAffinity: ListTileControlAffinity.platform,
                activeThumbColor: const Color(0xffffb703),
                title: const SizedBox(),
                value: cartilla.quantity == 1,
                onChanged: (value) {
                  setState(() {
                    cartilla.quantity = value ? 1 : 0;
                    cartilla.estado = value;
                  });
                  provider.updateEstado(cartilla.cartillaId.toString(), value);
                  provider.calculeTotal();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openAlertBox(
    BuildContext context,
    BingoProvider provider,
    int aditional,
    int counter,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mensaje de Sistema',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                Column(
                  children: [
                    const Text(
                      '¿Está seguro de agregar este progresivo?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'X${provider.counter}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Valor a cobrar',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      moneyFormatted(
                          double.parse(provider.preciofinal.toString())),
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        await provider.registerSale(
                          context,
                          forcedAditional: aditional,
                          forcedCounter: counter,
                        );
                        Navigator.of(context).pop();
                      },
                      child: const Text(
                        'Sí',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

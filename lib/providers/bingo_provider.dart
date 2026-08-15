import 'dart:convert';
import 'dart:io';
import 'package:bingo/core/data/models/bingoSala.dart';
import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/core/data/models/cartillaconvert.dart';
import 'package:bingo/core/data/models/requestQuey.dart';
import 'package:bingo/core/data/models/saleQuery.dart';
import 'package:bingo/utils/comparations.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as sdf;

class BingoProvider with ChangeNotifier {
  final pf = Preferencias();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  DateTime? _currentDate;
  DateTime get currentDate => _currentDate ?? DateTime.now();

  String _qrcode = "-1";
  String get qrcode => _qrcode;

  bool _isScanning = false;
  bool get isScanning => _isScanning;

  int _status = 1;
  int get status => _status;

  int _aditional = 0;
  int get aditional => _aditional;

  int _preciofinal = 0;
  int get preciofinal => _preciofinal;

  int _counter = 1;
  int get counter => _counter;

  bool get isPremioDiferidoGame => (bingo.presupuestoPremio ?? 0) <= 0;

  List<Bingo> _bingos = [];
  List<Bingo> get listBingos => _bingos;

  final List<Cartilla> _listBooklet = [];
  List<Cartilla> get listBooklet => _listBooklet;

  final List<Booklet> _infoBooklet = [];
  List<Booklet> get infoBooklet => _infoBooklet;

  Bingo _bingo = Bingo();
  Bingo get bingo => _bingo;

  String? _figure = '';
  String? get figure => _figure;

  final TextEditingController counterController = TextEditingController();

  BingoProvider() {
    counterController.text = _counter.toString();
    counterController.addListener(() {
      final value = int.tryParse(counterController.text);
      if (value != null && value >= 1 && value != _counter) {
        _counter = value;
        calculeTotal();
      }
    });
  }

  Future<void> getBingoById() async {
    final url = Uri.parse(
        '${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetItem/${bingo.bingoId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> info = json.decode(response.body);
        //print('Respuesta del servidor: $info');
        final bingoData = info['bingo'];
        final data = Bingo.fromMap(bingoData);
        //print('Bingo actualizado: $data');
        updateBingo(data);
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<List<Bingo>> fetchShowBingos(int state) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();    

    final url = Uri.parse(
        '${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetAll');
    /*print('url => $url');
    print(
        'dia filtrado => ${sdf.DateFormat('yyyy-MM-dd').format(currentDate)}');*/
    //print('estado filtrado => $state');

    try {
      final request = RequestQuery()
        ..isGlobal = false
        ..isIndividual = false
        ..fechaInicio = sdf.DateFormat('yyyy-MM-dd').format(currentDate)
        ..fechaFin = sdf.DateFormat('yyyy-MM-dd').format(currentDate)
        ..estado = state;

      //print('parametros => ${json.encode(request.toMap())} ');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toMap()));

      if (response.statusCode == 200) {
        final info = utf8.decode(response.bodyBytes);
        //print('response: $info');
        List<BingoSala> bingos = bingoSalaFromMap(info);

        if (bingos.isEmpty) {
          _bingos.clear();
          _isLoading = false;
          notifyListeners();
          /*debugPrint(
              '⚠️ No se encontraron bingos activos para el estado $state.');*/
          return [];
        }

        final premios = bingos.expand((item) => item.premios);
        final primerPremio = premios.isEmpty ? null : premios.first;
        if (primerPremio != null) {
          final figureGame = primerPremio.grupo ?? primerPremio.figura ?? '';
          updatefigure(figureGame);
        }
        //print('figura => $_figure');

        List<Bingo> nuevosBingos = obtenerBingos(bingos);
        bool sonIguales = listsEquals(_bingos, nuevosBingos);

        if (!sonIguales) {
          _bingos = nuevosBingos;

          for (var bingo in _bingos) {
            if (bingo.bingoId == pf.getBingoId) {
              updateBingo(bingo);
            }
          }
        }
        _isLoading = false;
        notifyListeners();
        return _bingos;
      } else {
        _bingos = [];
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load shows');
      }
    } on SocketException catch (_) {
      _bingos = [];
      _isLoading = false;
      notifyListeners();
      throw Exception('No se pudo conectar al servidor. Revisa tu red.');
    } on FormatException catch (e) {
      _bingos = [];
      _isLoading = false;
      errorMessage = 'Failed to load bingo shows: $e';
      notifyListeners();
      throw Exception('Error al parsear respuesta del servidor: $e');
    } catch (e) {
      _bingos = [];
      _isLoading = false;
      errorMessage = 'Failed to load bingo shows: $e';
      notifyListeners();
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Cartilla?> fetchShowscartilla(BuildContext context) async {
    /*print('===============================================================');
    print('***** busqueda de cartillas *****');
    print('info bingo => $bingo');
    print('modulo => $qrcode');
    print('===============================================================');*/

    _isLoading = true;
    clearBooklet();
    notifyListeners();

    try {
      final url = Uri.parse(
          '${pf.getIp.toString()}/api/GrupoCartillaDetalle/GetItemNameGrupo/$qrcode/${bingo.bingoId}');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        Cartilla booklet = cartillaFromJson(utf8.decode(response.bodyBytes));
        //print('cartilla encontrada => $booklet');

        if (booklet.grupoCartillas?.isNotEmpty == true) {
          double total = 0.0;
          _preciofinal = 0;
          double precio = bingo.precioPorCartilla ?? 0;

          var jsonData = jsonDecode(booklet.grupoCartillas!);
          //print('jsonData grupo cartillas => $jsonData');

          for (var numero in jsonData) {
            Booklet cartilla = Booklet();
            cartilla.cartillaId = numero.toString();
            cartilla.quantity = 1;
            cartilla.estado = true;
            cartilla.price = precio;

            total = total + precio;
            _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();

            booklet.listCartillas.add(cartilla);
            _infoBooklet.add(cartilla);
            _listBooklet.add(booklet);
          }
          //print('lista cartillas armadas => ${booklet.toJson()}');
          //print('lista _response => $_reponse');
          //print('lista _responsevalores => $_reponsevalores');
        } else {
          clearBooklet();
          const snackBar = SnackBar(
            content: Center(
                child: Text('No Hay Cartillas disponibles para la venta..')),
            backgroundColor: Colors.red,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
        _isLoading = false;
        notifyListeners();
        updateScan(false);
        //print('lista cartillas => $infoBooklet');
        return booklet;
      } else {
        _isLoading = false;
        notifyListeners();
        clearBooklet();
        updateScan(false);
        throw Exception(
            'Failed to load shows: Error HTTP ${response.statusCode}');
      }
    } on SocketException catch (e) {
      // 🔌 Error de red
      print('No hay conexión con el servidor: $e');
      reset();
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No se pudo conectar con el servidor. Verifica tu red.'),
          backgroundColor: Colors.red,
        ),
      );
    } catch (e) {
      print('Error inesperado: $e');
      reset();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error inesperado: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      _isLoading = false;
      updateScan(false);
      notifyListeners();
    }

    return Cartilla(
      grupoCartillas: '',
      listCartillas: [],
    );
  }

  Future<bool> registerSale(
    BuildContext context, {
    int? forcedAditional,
    int? forcedCounter,
  }) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    updateScan(true);
    SaleQuery sale = SaleQuery();
    List<Map<String, int>> booklets = [];
    //print('lista de cartillas escaneadas => ${infoBooklet.toString()}');
    if (infoBooklet.isNotEmpty) {
      for (var booklet in infoBooklet) {
        if (booklet.estado == true) {
          int newCartillaId = int.parse(booklet.cartillaId.toString());
          bool exists = booklets.any((b) => b['cartillaId'] == newCartillaId);
          if (!exists) {
            booklets.add({"cartillaId": newCartillaId});
          }
        }
      }
    }

    sale.ventaId = 0;
    sale.bingoId = bingo.bingoId;
    sale.clienteId = 0;
    sale.promotorId = pf.getPromotorId;
    sale.codigoModulo = qrcode;
    final int effectiveAditional = forcedAditional ?? _aditional;
    final int effectiveCounter = (forcedCounter ?? _counter) < 1 ? 1 : (forcedCounter ?? _counter);
    final bool isProgressiveSale = effectiveAditional == 2;

    sale.multiplicado = isProgressiveSale ? effectiveCounter : 0;
    sale.tipo = isProgressiveSale ? 3 : (effectiveAditional == 1 ? 2 : 1);
    sale.ventasDetalle = booklets;

    final String baseUrl = pf.getIp.toString().trim().replaceAll(RegExp(r'/+$'), '');
    final List<Uri> ventaEndpoints = [
      Uri.parse('$baseUrl/api/VentaInterno/PostVentaManual'),
      Uri.parse('$baseUrl/api/VentaInterno'),
      Uri.parse('$baseUrl/VentaInterno/PostVentaManual'),
      Uri.parse('$baseUrl/VentaInterno'),
    ];

    //print('body ventas => ${json.encode(sale.toMap())}');

    try {
      http.Response? response;
      for (final endpoint in ventaEndpoints) {
        final currentResponse = await http.post(
          endpoint,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(sale.toMap()),
        );

        response = currentResponse;

        // Stop at the first non-404 response (200, 400, 500, etc.).
        if (currentResponse.statusCode != 404) {
          break;
        }
      }

      if (response == null) {
        throw Exception('No se pudo ejecutar la venta en ningun endpoint.');
      }

      if (response.statusCode == 200) {
        final dynamic body = json.decode(response.body);
        final bool hasError =
            body is Map<String, dynamic> && (body['error'] == true);

        if (!hasError) {
          reset();
          const snackBar = SnackBar(
            content: Center(child: Text('Venta exitosa.')),
            backgroundColor: Colors.green,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          _isLoading = false;
          notifyListeners();
          updateScan(false);
          return true;
        }

        final String errorMessage = body is Map<String, dynamic>
            ? (body['errormensaje']?.toString().trim().isNotEmpty == true
                ? body['errormensaje'].toString()
                : 'No Se ha confirmado la venta.')
            : 'No Se ha confirmado la venta.';

        final snackBar = SnackBar(
          content: Center(child: Text(errorMessage)),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _isLoading = false;
        notifyListeners();
        updateScan(false);
        return false;
      } else {
        String errorMessage =
            'No Se ha confirmado la venta. (HTTP ${response.statusCode})';

        try {
          final dynamic body = json.decode(response.body);
          if (body is Map<String, dynamic> &&
              body['errormensaje']?.toString().trim().isNotEmpty == true) {
            errorMessage = body['errormensaje'].toString();
          }
        } catch (_) {
          // Keep generic HTTP-based message when response body is not JSON.
        }

        final snackBar = SnackBar(
          content: Center(child: Text(errorMessage)),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _isLoading = false;
        notifyListeners();
        updateScan(false);
        return false;
      }
    } catch (e) {
      //print('error => $e');
      const snackBar = SnackBar(
        content: Center(child: Text('Error al procesar la venta.')),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _isLoading = false;
      notifyListeners();
      updateScan(false);
      return false;
    }
  }

  void updateEstado(String cartillaId, bool newEstado) {
    Booklet? booklet = _infoBooklet.firstWhere(
      (item) => item.cartillaId == cartillaId,
      orElse: () => Booklet(),
    );

    if (booklet.cartillaId.toString().isNotEmpty) {
      booklet.estado = newEstado;
      notifyListeners();
    } else {
      print('No se encontró el Booklet con cartillaId: $cartillaId');
    }
  }

  void increment() {
    final day = DateTime.now();
    final isWeekday = day.weekday <= 5;
    final maxLimit = isWeekday ? 3 : 10;

    _counter++;
    if (_counter > maxLimit) _counter = maxLimit;

    counterController.text = _counter.toString();
    calculeTotal();
  }

  void decrement() {
    if (_counter > 1) {
      _counter--;
      counterController.text = _counter.toString();
    }
    calculeTotal();
  }

  void calculeTotal() {
    final double precio = bingo.precioPorCartilla ?? 0;
    final int cartillasSeleccionadas =
        infoBooklet.where((booklet) => booklet.estado == true).length;
    final double totalModulo = precio * cartillasSeleccionadas;
    switch (_aditional) {
      case 0:
        _preciofinal = totalModulo.round();
        break;
      case 1:
        _preciofinal = 0;
        break;
      case 2:
        _preciofinal = (totalModulo * (_counter + 1)).round();
        break;
      default:
        _preciofinal = 0;
        break;
    }
    notifyListeners();
  }

  void updatefigure(String value) {
    _figure = value;
    notifyListeners();
  }

  void updatestatus(int value) {
    _status = value;
    notifyListeners();
  }

  void updateLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void updateaditional(int value) {
    _aditional = value;
    calculeTotal();
  }

  void updateBingo(Bingo info) {
    _bingo = info;
    notifyListeners();
  }

  void updateCurrentDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners();
  }

  void updateQrcode(String newQrcode) {
    _qrcode = newQrcode;
    notifyListeners();
  }

  void updateScan(bool active) {
    _isScanning = active;
    notifyListeners();
  }

  void updateBingoState(List<Bingo> updatedBingos) {
    _bingos = updatedBingos;
    notifyListeners();
  }

  void updateCounter(int value) {
    if (value >= 1) {
      _counter = value;
      counterController.text = value.toString();
      calculeTotal();
    }
  }

  void clearBooklet() {
    _listBooklet.clear();
    _infoBooklet.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //updateQrcode('');
      notifyListeners();
    });
  }

  void reset() {
    _counter = 0;
    _preciofinal = 0;
    _aditional = 0;
    _qrcode = '-1';
    _isScanning = false;
    clearBooklet();
  }
}

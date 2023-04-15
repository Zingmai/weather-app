import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_bloc/cubit/weather_cubit.dart';

import 'model/weather.dart';

class WeatherSearchPage extends StatefulWidget {

  @override
  State<WeatherSearchPage> createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather Search'),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherCubit, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError) {
              /*Scaffold.of(context).setState(() {
                SnackBar(content: Text(state.message),);
              });*/
              /*Scaffold.of(context).showSnackBar(SnackBar(content: Text(state.message)));*/
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
              );
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(state.weather);
            } else {
              return buildInitialInput();
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Text(
          weather.cityName,
          style: TextStyle(fontSize: 40, fontWeight: FontWeight.w700),
        ),
        Text(
          "${weather.temperatureCelsius.toStringAsFixed(1)}°C",
          style: TextStyle(fontSize: 80),
        ),
        CityInputField()
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
            hintText: 'Enter a city',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            suffixIcon: Icon(Icons.search)),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    /*final weatherCubit = context.bloc<WeatherCubit>();
    weatherCubit.getWeather(cityName);*/
    context.read<WeatherCubit>().getWeather(cityName);
  }
}

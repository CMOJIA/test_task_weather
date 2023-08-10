import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:formz/formz.dart';
import 'package:test_task_weather_service/login/view/cubit/login_cubit.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(state.errorMessage ??
                    'Ошибка авторизации. Проверьте подключение к интернету или попробуйте позже.'),
              ),
            );
        }
      },
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _Title(),
              _EmailInput(),
              _PasswordInput(),
              // Под TextField для пароля пространство в 11px, зачем и почему не понятно
              const SizedBox(
                height: 11,
              ),

              _LoginButton(),
            ],
          ),
        ),
      ),
    );
  }
}

class _Title extends StatelessWidget {
  const _Title();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        // Сверху оступ в 48px на макете, явно не SafeArea
        top: 48,
        left: 24,
        right: 24,
        bottom: 16,
      ),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Вход',
            style: TextStyle(
              color: Color(0xFF2B2D33),
              fontSize: 28,
              fontFamily: 'Ubuntu',
              fontWeight: FontWeight.w500,
              height: 1.2,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Введите данные для входа ',
            style: TextStyle(
              color: Color(0xFF8799A5),
              fontSize: 15,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.email != current.email,
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.only(
            top: 8,
            left: 24,
            right: 24,
            bottom: 24,
          ),
          child: TextField(
            key: const Key('loginForm_emailInput_textField'),
            onChanged: (email) =>
                context.read<LoginCubit>().emailChanged(email),
            keyboardType: TextInputType.emailAddress,
            cursorWidth: 1,
            decoration: const InputDecoration(
              labelText: 'Email',
            ),
            style: const TextStyle(
              color: Color(0xFF2B2D33),
              fontSize: 17,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
}

class _PasswordInput extends StatefulWidget {
  @override
  State<_PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<_PasswordInput> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      buildWhen: (previous, current) => previous.password != current.password,
      builder: (context, state) {
        return Container(
          margin: const EdgeInsets.only(
            top: 8,
            left: 24,
            right: 24,
            bottom: 8,
          ),
          child: TextField(
            key: const Key('loginForm_passwordInput_textField'),
            onChanged: (password) =>
                context.read<LoginCubit>().passwordChanged(password),
            obscureText: isObscure,
            cursorWidth: 1.5,
            decoration: InputDecoration(
              labelText: 'Пароль',
              suffixIcon: IconButton(
                onPressed: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                icon: isObscure
                    ? SvgPicture.asset(
                        'assets/svgIcons/Mask.svg',
                      )
                    : Icon(
                        isObscure
                            ? Icons.visibility_outlined
                            : Icons.visibility,
                        color: const Color(0xFF0600FF),
                      ),
              ),
            ),
            style: const TextStyle(
              color: Color(0xFF2B2D33),
              fontSize: 17,
              fontFamily: 'Roboto',
              fontWeight: FontWeight.w400,
            ),
          ),
        );
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<LoginCubit, LoginState>(
      builder: (context, state) {
        return state.status.isInProgress
            ? const Center(
                child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(
                  color: Color(0xFF0600FF),
                ),
              ))
            : Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  key: const Key('loginForm_continue_raisedButton'),
                  onPressed: state.isValid
                      ? () => context.read<LoginCubit>().logInWithCredentials()
                      : null,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Войти',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }
}

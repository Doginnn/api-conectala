<?php

use Illuminate\Support\Facades\Route;
use App\Http\Controllers\UserController;

# Routs to User
Route::get('/', [UserController::class, 'index'])->name('index');
Route::get('/users/{id}', [UserController::class, 'show'])->name('show');
Route::post('/users', [UserController::class, 'store'])->name('store');
Route::put('/users/{id}', [UserController::class, 'update'])->name('update');
Route::delete('/users/{id}', [UserController::class, 'destroy'])->name('destroy');

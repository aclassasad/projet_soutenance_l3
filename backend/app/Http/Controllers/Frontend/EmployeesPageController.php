<?php

namespace App\Http\Controllers\Frontend;

use App\Http\Controllers\Controller;

class EmployeesPageController extends Controller
{
    public function index()
    {
        return view('employees');
    }
}
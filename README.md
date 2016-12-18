# ESXi health

This is a collection of ESXi health checkers for Nagios/Sensu. There are two
number exposed by [rbvmomi][rbvmomi] and these check against them. This can
be used to look directly at a ESXi host and alert on high percentage usage
for both CPU and RAM.

## Installation

This requires the `rbvmomi` gem, so in order to run this you need to do something
like the following:

```shell
$ git clone https://github.com/jjasghar/esxi_health
$ cd esxi_health
$ bundle install
```

## Running

There are multiple way's to run this inside of Sensu/Nagios, but to test via the
installation options you can run:

```shell
$ cd esxi_health
$ ruby checks/esxi_memory_stats.rb --hostname ESXIHOST -n NAMEOFESXIHOST -P USERNAMEPASSWORD -u USERNAME -p 60
OK: ESXi is under the max memory usage using 60.0%
```

## Sensu Checks

Here is an example Sensu check:

```json
{
  "checks": {
    "esxi_memory": {
      "command": "esxi_memory_stats.rb --hostname ESXIHOST -n NAMEOFESXIHOST -P USERNAMEPASSWORD -u USERNAME -p 60",
      "standalone": true,
      "subscribers": [
        "esxi"
      ],
      "interval": 60
    }
  }
}
```

Don't forget you'll need to inject `rbvmomi` into the embedded sensu ruby install:

```shell
$ /opt/sensu/embedded/bin/gem install rbvmomi
```

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Submit a Pull Request using Github

## License and Authors

* Author:: [JJ Asghar](https://github.com/jjasghar)

Copyright:: 2016 JJ Asghar

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

[rbvmomi]: https://github.com/vmware/rbvmomi
